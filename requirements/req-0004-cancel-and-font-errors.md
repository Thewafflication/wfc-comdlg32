# REQ-0004 — Cancel and the error numbers of the dialogs

**Content type:** Project requirement

**Status:** Proposed

**Source:** The documented errors of `MSComDlg.CommonDialog`. Replaces part of
the former REQ-0304 (see `docs/id-map.md`).

## Scope

The error numbers, the `ShowFont` font-kind rule and the meaning of a
scripted `cancel` of `wfc/comdlg32/dialogs.hpp`. The raising of the errors by
the evaluator is checked in WFC.

## Requirement

1. The error number raised when the user cancels with `CancelError` set shall
   be 32755 ("Cancel was selected").
2. The error number raised by `ShowFont` when `Flags` holds neither
   `cdlCFScreenFonts` (1) nor `cdlCFPrinterFonts` (2) shall be 24574 ("No
   fonts exist"); `ShowFont` shall list fonts when `Flags` holds either bit or
   both.
3. A scripted answer `cancel`, in any ASCII letter case, shall stand for the
   user cancelling; no other answer (`cancelled`, a path, the empty text)
   shall.
4. A cancelled dialog shall leave the properties of the control unchanged.

## Rationale

Programs test `Err.Number` against these values to tell a cancel from a real
failure.

## Verification

**Method:** Test

**References:** `TC-0003`, `TC-0004`

`TC-0003` checks items 1 to 3; `TC-0004` shows items 3 and 4 through a form (a
cancelled colour dialog keeps its colour).

## Relationships

- **Derived from:** `comdlg32.ocx` 6.1.98.
- **Depends on:** `REQ-0005` (the scripted answers).
- **Conflicts with:** None.

## Tailoring

None.

## Implementation Record

`include/wfc/comdlg32/dialogs.hpp`; the evaluator raises the errors
(`include/wfc/comdlg32/comdlg32.inc`).
