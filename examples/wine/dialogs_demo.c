/* Opens one of the Windows common dialogs that the Common Dialog control of
 * WFC shows (ShowOpen, ShowColor, ShowFont): `dialogs_demo open|color|font`.
 * CI builds it with Wine's winegcc and photographs the dialog under Wine on
 * Linux for the README. */
#include <windows.h>
#include <commdlg.h>
#include <string.h>

int WINAPI WinMain(HINSTANCE instance, HINSTANCE previous, LPSTR command,
                   int show) {
    (void)instance;
    (void)previous;
    (void)show;
    if (strstr(command, "color") != NULL) {
        CHOOSECOLORA color;
        COLORREF custom[16] = {0};
        ZeroMemory(&color, sizeof(color));
        color.lStructSize = sizeof(color);
        color.lpCustColors = custom;
        color.rgbResult = RGB(255, 0, 255);
        color.Flags = CC_FULLOPEN | CC_RGBINIT;
        ChooseColorA(&color);
    } else if (strstr(command, "font") != NULL) {
        LOGFONTA face;
        CHOOSEFONTA font;
        ZeroMemory(&face, sizeof(face));
        ZeroMemory(&font, sizeof(font));
        lstrcpyA(face.lfFaceName, "Courier New");
        face.lfHeight = -16;
        font.lStructSize = sizeof(font);
        font.lpLogFont = &face;
        font.Flags = CF_SCREENFONTS | CF_EFFECTS | CF_INITTOLOGFONTSTRUCT;
        ChooseFontA(&font);
    } else {
        OPENFILENAMEA open;
        char file[MAX_PATH] = "notes.txt";
        ZeroMemory(&open, sizeof(open));
        open.lStructSize = sizeof(open);
        open.lpstrFilter = "Text (*.txt)\0*.txt\0All files\0*.*\0";
        open.lpstrFile = file;
        open.nMaxFile = MAX_PATH;
        open.Flags = OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST;
        GetOpenFileNameA(&open);
    }
    return 0;
}
