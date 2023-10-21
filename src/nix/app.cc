#include "installables.hh"
#include "installable-derived-path.hh"
#include "installable-value.hh"
#include "store-api.hh"
#include "eval-inline.hh"
#include "eval-cache.hh"
#include "names.hh"
#include "command.hh"
#include "derivations.hh"
#include "downstream-placeholder.hh"

namespace nix {

/**
 * Return the rewrites that are needed to resolve a string whose context is
 * included in `dependencies`.
 */
StringPairs resolveRewrites(
    Store & store,
    const std::vector<BuiltPathWithResult> & dependencies)
{
    StringPairs res;
    if (!experimentalFeatureSettings.isEnabled(Xp::CaDerivations)) {
        return res;
    }
    for (auto &dep: dependencies) {
        auto drvDep = std::get_if<BuiltPathBuilt>(&dep.path);
        if (!drvDep) {
            continue;
        }

        for (auto & [ outputName, outputPath ] : drvDep->outputs) {
            res.emplace(
                DownstreamPlaceholder::fromSingleDerivedPathBuilt(
                    SingleDerivedPath::Built {
                        .drvPath = make_ref<SingleDerivedPath>(drvDep->drvPath->discardOutputPath()),
                        .output = outputName,
                    }).render(),
                store.printStorePath(outputPath)
            );
        }
    }
    return res;
}

/**
 * Resolve the given string assuming the given context.
 */
std::string resolveString(
    Store & store,
    const std::string & toResolve,
    const std::vector<BuiltPathWithResult> & dependencies)
{
    auto rewrites = resolveRewrites(store, dependencies);
    return rewriteStrings(toResolve, rewrites);
}

UnresolvedApp InstallableValue::toApp(EvalState & state)
{
    auto cursor = getCursor(state);
    auto attrPath = cursor->getAttrPath();

    auto cursorType = cursor->getAttr("type")->getString();

    std::string expectedType = !attrPath.empty() &&
        (state.symbols[attrPath[0]] == "apps" || state.symbols[attrPath[0]] == "defaultApp")
        ? "app" : "derivation";
    if (cursorType != expectedType)
        throw Error("attribute '%s' should have type '%s'", cursor->getAttrPathStr(), expectedType);

    if (cursorType == "app") {
        auto [program, context] = cursor->getAttr("program")->getStringWithContext();

        std::vector<DerivedPath> context2;
        for (auto & c : context) {
            context2.emplace_back(std::visit(overloaded {
                [&](const NixStringContextElem::DrvDeep & d) -> DerivedPath {
                    /* We want all outputs of the drv */
                    return DerivedPath::Built {
                        .drvPath = makeConstantStorePathRef(d.drvPath),
                        .outputs = OutputsSpec::All {},
                    };
                },
                [&](const NixStringContextElem::Built & b) -> DerivedPath {
                    return DerivedPath::Built {
                        .drvPath = b.drvPath,
                        .outputs = OutputsSpec::Names { b.output },
                    };
                },
                [&](const NixStringContextElem::Opaque & o) -> DerivedPath {
                    return DerivedPath::Opaque {
                        .path = o.path,
                    };
                },
            }, c.raw));
        }

        return UnresolvedApp { App {
            .context = std::move(context2),
            .program = program,
        }};
    }

    if (cursorType == "derivation") {
        auto drvPath = cursor->forceDerivation();
        auto outPath = cursor->getAttr(state.sOutPath)->getString();
        auto outputName = cursor->getAttr(state.sOutputName)->getString();
        auto name = cursor->getAttr(state.sName)->getString();
        auto aPname = cursor->maybeGetAttr("pname");
        auto aMeta = cursor->maybeGetAttr(state.sMeta);
        auto aMainProgram = aMeta ? aMeta->maybeGetAttr("mainProgram") : nullptr;
        auto mainProgram =
            aMainProgram
            ? aMainProgram->getString()
            : aPname
            ? aPname->getString()
            : DrvName(name).name;
        auto program = outPath + "/bin/" + mainProgram;
        return UnresolvedApp { App {
            .context = { DerivedPath::Built {
                .drvPath = makeConstantStorePathRef(drvPath),
                .outputs = OutputsSpec::Names { outputName },
            } },
            .program = program,
        }};
    }

    throw Error("attribute '%s' has unsupported type '%s'", cursor->getAttrPathStr(), cursorType);
}

// FIXME: move to libcmd
App UnresolvedApp::resolve(ref<Store> evalStore, ref<Store> store)
{
    auto res = unresolved;

    Installables installableContext;

    for (auto & ctxElt : unresolved.context)
        installableContext.push_back(
            make_ref<InstallableDerivedPath>(store, DerivedPath { ctxElt }));

    auto builtContext = Installable::build(evalStore, store, Realise::Outputs, installableContext);
    res.program = resolveString(*store, unresolved.program, builtContext);
    if (!store->isInStore(res.program))
        throw Error("app program '%s' is not in the Nix store", res.program);

    return res;
}

}
