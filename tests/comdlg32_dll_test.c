/* Black-box check of wfccomdlg32.dll: exports, version resource and the
 * registration round trip (see dll_check.h). Run by CTest with the DLL,
 * the version and the target as arguments. */
#include "dll_check.h"

static const struct wfc_check_class kClasses[] = {
    {L"WFC.MSComDlg.CommonDialog", L"{CF6A2C7A-4FCB-5C54-9568-046A730724E8}",
     L"MSComDlg.CommonDialog.1", L"{F9043C85-F6F2-101A-A3C9-08002B2F49FB}"},
};

int main(int argc, char** argv) {
    int checked = wfc_check_dll(argc, argv, L"comdlg32", kClasses,
                                sizeof(kClasses) / sizeof(kClasses[0]));
    if (checked != 0) {
        return checked;
    }
    return wfc_check_create(wfc_check_widen(argv[1]),
                            L"{CF6A2C7A-4FCB-5C54-9568-046A730724E8}",
                            L"CancelError", L"ShowColor");
}
