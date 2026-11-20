# Identifier map

**Content type:** Project record

The requirement and test-case identifiers of this library were first numbered
in the global sequence of the WFC repository (`REQ-0304`, `TC-MP0010-*`,
`TC-MP0002-corpus-*`). The library is a repository of its own and numbers its
artifacts from 0001 in its own namespace (WSP `style/artifact-identifiers.md`:
`REQ-NNNN`, `TC-NNNN`). This file keeps the link to the historical identifiers;
a historical identifier is never reused here.

## Requirements

| Old ID | Old title | New ID | New title |
| --- | --- | --- | --- |
| REQ-0304 | Common Dialog control (`MSComDlg.CommonDialog`) | REQ-0001 | The library DLL exports, versions and registers |
| | | REQ-0002 | The member table of the CommonDialog class |
| | | REQ-0003 | FileTitle and FilterIndex rules |
| | | REQ-0004 | Cancel and the error numbers of the dialogs |
| | | REQ-0005 | Scripted answers stand for the choice of the user |
| | | REQ-0006 | The system dialogs on a Win32 host |

REQ-0304 held one statement for the whole control; it is split into
verifiable requirements. Its statements on the class resolving in forms, the
`Object=` lines, the property defaults and the constants belong to the
evaluator in WFC and are listed as informative text in REQ-0002.

## Test cases

| Old ID | Old title | New ID | Specification |
| --- | --- | --- | --- |
| TC-MP0010-comdlg32-dll | CTest: DLL exports, version, registration | TC-0001-comdlg32-dll | `tests/tc-0001-comdlg32-dll.tex` |
| TC-MP0010-comdlg32-tables | CTest: member table | TC-0002-comdlg32-tables | `tests/tc-0002-comdlg32-tables.tex` |
| TC-MP0010-comdlg32-dialogs | CTest: rules of the dialogs | TC-0003-comdlg32-dialogs | `tests/tc-0003-comdlg32-dialogs.tex` |
| TC-MP0002-corpus-207-win-dialogs-classes | WFC corpus case `207-win-dialogs-classes` | TC-0004-win-dialogs-classes | `tests/tc-0004-win-dialogs-classes.tex` |
| (none) | The Win32 system dialogs, by hand | TC-0005-win32-system-dialogs | `tests/tc-0005-win32-system-dialogs.tex` |

`TC-MP0002-corpus-207-win-dialogs-classes` is still the name under which the
WFC repository registers the corpus case (WFC names every corpus case that
way); `TC-0004-win-dialogs-classes` is the name in this repository.
The corpus case files keep their names.

The old requirement named the corpus case `196-ocx-winsock-dialog`; that case
belongs to wfc-mswinsck and was a mistake here.

## Where the old identifiers are still used

The WFC repository (not edited from here) mentions them in:
`planning/MP-0006-mscomctllib.md` (`REQ-0296`-`REQ-0304`),
`planning/MP-0008-closeout.md`, `planning/MP-0008-project-compatibility.md`
and `planning/work-log-mp-0008.md` (`REQ-0304`), and the work log
`planning/MP-0010-distribution-and-libraries.md`.
