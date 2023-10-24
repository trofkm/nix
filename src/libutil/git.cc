#include "git.hh"

#include <regex>

namespace nix {
namespace git {

std::optional<RemoteRef> RemoteRef::fromString(std::string_view line)
{
    const static std::regex line_regex("^(ref: *)?([^\\s]+)(?:\\t+(.*))?$");
    std::match_results<std::string_view::const_iterator> match;
    if (!std::regex_match(line.cbegin(), line.cend(), match, line_regex))
        return std::nullopt;

    return RemoteRef {
        .kind = match[1].length() == 0
            ? RemoteRef::Kind::Object
            : RemoteRef::Kind::Symbolic,
        .target = match[2],
        .reference = match[3].length() == 0 ? std::nullopt : std::optional<std::string>{ match[3] }
    };
}

}
}
