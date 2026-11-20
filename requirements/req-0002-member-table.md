# REQ-0002 — The member table of the CommonDialog class

**Content type:** Project requirement

**Status:** Proposed

**Source:** The documented members of `MSComDlg.CommonDialog` in
`comdlg32.ocx` (Visual Basic 6.0 SP6). Replaces part of the former REQ-0304
(see `docs/id-map.md`).

## Scope

The table returned by `wfc::ui::comdlg32_classes()`; the behaviour of the
members lives in the WFC evaluator and is outside this requirement.

## Requirement

1. `wfc::ui::comdlg32_classes()` shall return exactly one class, named
   `CommonDialog`.
2. The class shall list at least one member, every member shall have a
   non-empty name, and the kind of every member shall be one of `g` (get),
   `l` (let), `s` (set) or `m` (method).
3. Every event the class lists shall be of kind `m`.

The members the table stands for are the properties `Action`, `CancelError`,
`Color`, `Copies`, `DefaultExt`, `DialogTitle`, `FileName`, `FileTitle`,
`Filter`, `FilterIndex`, `Flags`, `FontBold`, `FontItalic`, `FontName`,
`FontSize`, `FontStrikethru`, `FontUnderline`, `FromPage`, `HelpCommand`,
`HelpContext`, `HelpFile`, `HelpKey`, `InitDir`, `Max`, `MaxFileSize`, `Min`,
`Orientation`, `PrinterDefault`, `ToPage`, `hDC` and the methods `ShowOpen`,
`ShowSave`, `ShowColor`, `ShowFont`, `ShowPrinter`, `ShowHelp`, with the
constants `cdlCancel`, `cdlOFN*`, `cdlCF*` and `cdlCC*`.

## Rationale

The evaluator and the DLL build their objects from this table; a nameless
member or an unknown kind would make a control unusable.

## Verification

**Method:** Test

**References:** `TC-0002`

The test checks the structure of the table. That each documented member is
present with the right type is not yet checked here (`COMPATIBILITY.md`).

## Relationships

- **Derived from:** `comdlg32.ocx` 6.1.98.
- **Depends on:** None.
- **Conflicts with:** None.

## Tailoring

None.

## Implementation Record

`src/comdlg32_tables.cpp`, `include/wfc/comdlg32/comdlg32.hpp`.
