# REQ-0006 — The system dialogs on a Win32 host

**Content type:** Project requirement

**Status:** Proposed

**Source:** The documented behaviour of `MSComDlg.CommonDialog`. Replaces part
of the former REQ-0304 (see `docs/id-map.md`).

## Scope

A Win32 host with windows (Windows, or Wine). `ShowPrinter` and `ShowHelp`
open no dialog yet and are outside this requirement.

## Requirement

1. `ShowOpen`, `ShowSave`, `ShowColor` and `ShowFont` shall open the system
   dialogs (`GetOpenFileName`, `GetSaveFileName`, `ChooseColor`,
   `ChooseFont`), and assigning 1 to 4 to `Action` shall open the same
   dialogs as the four methods.
2. When the user chooses a file the control shall set `FileName`, `FileTitle`
   and `FilterIndex`; when the user chooses a colour it shall set `Color`;
   when the user chooses a font it shall set the `Font*` properties.
3. When the user cancels and `CancelError` is true the control shall raise
   error 32755; when `CancelError` is false it shall raise no error and leave
   the properties unchanged.

## Known limits

No printer dialog, no help launch, no hook or template flags, no multi-select
file lists, and `hDC` is zero.

## Rationale

This is the behaviour a Visual Basic 6 program that uses the dialogs depends
on.

## Verification

**Method:** Test (manual: the system dialogs are modal)

**References:** `TC-0005`

## Relationships

- **Derived from:** `comdlg32.ocx` 6.1.98.
- **Depends on:** `REQ-0004`.
- **Conflicts with:** None.

## Tailoring

None.

## Implementation Record

`include/wfc/comdlg32/comdlg32.inc` (the evaluator part); the demonstration
`examples/wine/dialogs_demo.c` opens the same system dialogs.
