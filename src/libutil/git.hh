#pragma once
///@file

#include <string>
#include <string_view>
#include <optional>

namespace nix {

namespace git {

/**
 * A line from the output of `git ls-remote --symref`.
 *
 * These can be of two kinds:
 *
 * - Symbolic references of the form
 *
 *      ref: {target}	{reference}
 *
 *    where {target} is itself a reference and {reference} is optional
 *
 * - Object references of the form
 *
 *      {target}	{reference}
 *
 *    where {target} is a commit id and {reference} is mandatory
 */
struct RemoteRef {
    enum struct Kind {
        Symbolic,
        Object
    };
    Kind kind;
    std::string target;
    std::optional<std::string> reference;

    /**
     * @brief Construct RemoteRef from a string
     * @param line input from `git ls-remote --symref`
     * @return std::nullopt if something went wrong or RemoteRef
     */
    static std::optional<RemoteRef> fromString(std::string_view line);
};


}

}
