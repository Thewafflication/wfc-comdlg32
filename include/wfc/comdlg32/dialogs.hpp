// The rules of the Common Dialog, apart from any window, control or
// evaluator: the file title of a path, the font flags that leave no font to
// choose from, the filter index, what a scripted answer means, and the
// Visual Basic error numbers. Header only, with no dependency on the WFC
// evaluator or on Windows; the evaluator and the tests use it. Internal to the
// WFC libraries.

#ifndef WFC_COMDLG32_DIALOGS_HPP
#define WFC_COMDLG32_DIALOGS_HPP

#include <algorithm>
#include <cstdlib>
#include <string>
#include <string_view>
#include <vector>

namespace wfc::comdlg32 {

// cdlCancel: the user cancelled and CancelError is set.
inline constexpr long kCancelled = 32755;
// cdlNoFonts: ShowFont with neither screen nor printer fonts in Flags.
inline constexpr long kNoFonts = 24574;

inline constexpr long kScreenFonts = 0x1;   // cdlCFScreenFonts
inline constexpr long kPrinterFonts = 0x2;  // cdlCFPrinterFonts

// FileTitle: the name of the file without its folder.
[[nodiscard]] inline std::string file_title(const std::string_view path) {
    const auto at = path.find_last_of("/\\");
    return std::string(at == std::string_view::npos ? path
                                                    : path.substr(at + 1U));
}

// ShowFont needs a kind of font to list.
[[nodiscard]] constexpr bool fonts_available(const long flags) {
    return (flags & (kScreenFonts | kPrinterFonts)) != 0;
}

// FilterIndex is at least 1.
[[nodiscard]] constexpr long normalized_filter_index(const long wanted) {
    return wanted < 1 ? 1 : wanted;
}

// A scripted answer of `Cancel` (any letter case, ASCII) stands for the user
// cancelling.
[[nodiscard]] inline bool answer_cancels(const std::string_view answer) {
    constexpr std::string_view cancel = "cancel";
    if (answer.size() != cancel.size()) {
        return false;
    }
    for (std::size_t i = 0; i < cancel.size(); ++i) {
        const char c = answer[i];
        if ((c >= 'A' && c <= 'Z' ? c - 'A' + 'a' : c) != cancel[i]) {
            return false;
        }
    }
    return true;
}

// The font a scripted answer `Name,Size,Bold,Italic` chooses: the parts that
// are given replace those of `base` (Bold and Italic are 0 or 1).
struct FontChoice {
    std::string name;
    double size = 8.0;
    bool bold = false;
    bool italic = false;
};

// A whole number as a script writes it: decimal or &H hexadecimal.
[[nodiscard]] inline long scripted_number(std::string text) {
    while (!text.empty() && text.front() == ' ') {
        text.erase(0, 1);
    }
    if (text.size() > 2U && text[0] == '&' &&
        (text[1] == 'h' || text[1] == 'H')) {
        return static_cast<long>(std::strtoul(text.c_str() + 2, nullptr, 16) &
                                 0xFFFFFFFFUL);
    }
    return std::strtol(text.c_str(), nullptr, 10);
}

[[nodiscard]] inline FontChoice scripted_font(FontChoice base,
                                              const std::string& answer) {
    std::vector<std::string> parts;
    std::string part;
    for (const char c : answer) {
        if (c == ',') {
            parts.push_back(part);
            part.clear();
        } else {
            part.push_back(c);
        }
    }
    if (!part.empty()) {
        parts.push_back(part);
    }
    if (!parts.empty()) {
        base.name = parts[0];
    }
    if (parts.size() > 1U) {
        base.size = std::strtod(parts[1].c_str(), nullptr);
    }
    if (parts.size() > 2U) {
        base.bold = scripted_number(parts[2]) != 0;
    }
    if (parts.size() > 3U) {
        base.italic = scripted_number(parts[3]) != 0;
    }
    return base;
}

}  // namespace wfc::comdlg32

#endif  // WFC_COMDLG32_DIALOGS_HPP
