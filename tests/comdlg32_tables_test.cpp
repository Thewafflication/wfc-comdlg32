// Checks the member table of the Common Dialog library: its classes, and that
// every class lists named members of a known kind.

#include <wfc/comdlg32/comdlg32.hpp>

#include <cstddef>
#include <cstdio>
#include <cstring>

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
    static const char* const expected[] = {"CommonDialog"};
    constexpr std::size_t kExpected = sizeof(expected) / sizeof(expected[0]);
    const auto classes = wfc::ui::comdlg32_classes();
    expect(classes.size() == kExpected, "the number of classes");
    for (std::size_t i = 0; i < classes.size() && i < kExpected; ++i) {
        const wfc::ui::ControlClass& entry = classes[i];
        expect(std::strcmp(entry.name, expected[i]) == 0, entry.name);
        expect(entry.member_count > 0U, "a class without members");
        for (std::size_t m = 0; m < entry.member_count; ++m) {
            const wfc::ui::MemberRow& row = entry.members[m];
            expect(row.name != nullptr && row.name[0] != '\0',
                   "a nameless member");
            expect(std::strchr("glsm", row.kind) != nullptr,
                   "an unknown member kind");
        }
        for (std::size_t e = 0; e < entry.event_count; ++e) {
            expect(entry.events[e].kind == 'm',
                   "an event that is not a method");
        }
    }
    if (failures == 0) {
        std::printf("comdlg32: %zu classes\n", classes.size());
    }
    return failures == 0 ? 0 : 1;
}
