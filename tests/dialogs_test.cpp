// Checks the rules of the Common Dialog (wfc/comdlg32/dialogs.hpp).

#include <wfc/comdlg32/dialogs.hpp>

#include <cstdio>

namespace {

int failures = 0;

void expect(const bool condition, const char* what) {
    if (!condition) {
        std::fprintf(stderr, "FAIL: %s\n", what);
        ++failures;
    }
}

}  // namespace

int main() {
    using namespace wfc::comdlg32;

    expect(file_title("C:\\data\\notes.txt") == "notes.txt" &&
               file_title("/home/a/b.bas") == "b.bas" &&
               file_title("plain.txt") == "plain.txt" &&
               file_title("C:\\dir\\").empty() && file_title("").empty(),
           "the file title");
    expect(kCancelled == 32755 && kNoFonts == 24574, "the error numbers");
    expect(fonts_available(kScreenFonts) && fonts_available(kPrinterFonts) &&
               fonts_available(3) && !fonts_available(0) &&
               !fonts_available(0x100),
           "ShowFont needs a kind of font");
    expect(normalized_filter_index(0) == 1 &&
               normalized_filter_index(-4) == 1 &&
               normalized_filter_index(3) == 3,
           "the filter index is at least 1");
    expect(answer_cancels("cancel") && answer_cancels("Cancel") &&
               answer_cancels("CANCEL") && !answer_cancels("cancelled") &&
               !answer_cancels("C:\\x") && !answer_cancels(""),
           "a scripted cancel");
    expect(scripted_number("&HFF00FF&") == 0xFF00FF &&
               scripted_number(" 12") == 12 && scripted_number("&h10") == 16 &&
               scripted_number("x") == 0,
           "scripted numbers");

    FontChoice base;
    base.name = "Arial";
    base.size = 10.0;
    const FontChoice all = scripted_font(base, "Courier New,12,1,0");
    expect(all.name == "Courier New" && all.size == 12.0 && all.bold &&
               !all.italic,
           "a whole font answer");
    const FontChoice name_only = scripted_font(base, "Times");
    expect(
        name_only.name == "Times" && name_only.size == 10.0 && !name_only.bold,
        "the parts not given stay");
    const FontChoice italic = scripted_font(base, "Arial,9,0,&H1");
    expect(italic.size == 9.0 && !italic.bold && italic.italic,
           "bold and italic are numbers");

    if (failures == 0) {
        std::puts("dialogs: ok");
    }
    return failures == 0 ? 0 : 1;
}
