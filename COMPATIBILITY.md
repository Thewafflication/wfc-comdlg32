# wfc-comdlg32: compatibility with comdlg32.ocx

Target: **COMDLG32.OCX 6.1.98 (Visual Basic 6.0 SP6)**. Library version: **0.6.1**.

Written by hand from the documented members of the control.

## Surface

| Class | Members | Events | Table | Behaviour |
| --- | ---: | ---: | --- | --- |
| CommonDialog | 65 | 0 | listed | in the WFC evaluator |

1 class(es), 65 members and 0 events are in
the table. *Table* means the member exists with the Microsoft name, kind, type
and dispatch id. *Behaviour* is implemented by the WFC evaluator and covered by
its corpus and GUI tests (`TC-MP0006-*`, `TC-MP0010-*`); per-member behaviour
status is tracked in WFC until the behaviour moves into this library (see the
[roadmap](ROADMAP.md), 0.7).

## Registration

| Item | WFC | Microsoft |
| --- | --- | --- |
| ProgID and class id | `WFC.MSComDlg.<Class>`, a fixed UUID per class | `MSComDlg.<Class>`, the Microsoft class id |
| Selected by | the default | `WFC_REGISTER_MICROSOFT_IDS=1` (the previous server is saved and restored on unregister) |
| COM creation | `DllGetClassObject` gives a class factory; the object is a table-driven IDispatch (properties stored, methods accepted) | n/a |

## Known gaps

- Per-member behaviour is not measured yet.
- The class id {F9043C85-F6F2-101A-A3C9-08002B2F49FB} and the ProgID MSComDlg.CommonDialog.1 were written from memory and are not yet checked against a Microsoft installation.
- `DllGetClassObject` does not create controls yet; a program that creates the
  control through COM does not get one from this library (roadmap 0.7).

## How it is checked

- A C program (`tests/comdlg32_dll_test.c`) loads the DLL, checks its COM entry
  points and version resource, and registers and unregisters it.
- A table test (`tests/comdlg32_tables_test.cpp`) checks the classes and the
  member kinds.
- WFC compares the table with the type-library evidence
  (`TC-MP0006-comctl-tables-current` for the generated tables) and runs its
  corpus programs against the controls.
