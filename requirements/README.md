# wfc-comdlg32 requirements

**Content type:** Project requirement index

Requirements use `REQ-NNNN` identifiers numbered in this library's own
namespace; the test cases (`TC-NNNN`) are in `tests/`. The former identifier
`REQ-0304` of the WFC repository is mapped in [../docs/id-map.md](../docs/id-map.md).

| Requirement | Subject | Verified by |
| --- | --- | --- |
| [REQ-0001](req-0001-library-dll.md) | The library DLL exports, versions and registers | TC-0001 |
| [REQ-0002](req-0002-member-table.md) | The member table of the CommonDialog class | TC-0002 |
| [REQ-0003](req-0003-file-title-and-filter-index.md) | FileTitle and FilterIndex rules | TC-0003, TC-0004 |
| [REQ-0004](req-0004-cancel-and-font-errors.md) | Cancel and the error numbers of the dialogs | TC-0003, TC-0004 |
| [REQ-0005](req-0005-scripted-answers.md) | Scripted answers stand for the choice of the user | TC-0003, TC-0004 |
| [REQ-0006](req-0006-win32-system-dialogs.md) | The system dialogs on a Win32 host | TC-0005 (manual) |

The traceability check (`scripts/Test-Traceability.ps1`) verifies the links in
both directions.
