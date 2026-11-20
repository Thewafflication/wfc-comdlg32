# REQ-0003 — FileTitle and FilterIndex rules

**Content type:** Project requirement

**Status:** Proposed

**Source:** The documented behaviour of `MSComDlg.CommonDialog.FileTitle` and
`FilterIndex`. Replaces part of the former REQ-0304 (see `docs/id-map.md`).

## Scope

`file_title` and `normalized_filter_index` of `wfc/comdlg32/dialogs.hpp`, which
the evaluator uses after a file is chosen.

## Requirement

1. `FileTitle` shall be the name of the chosen file without its folder: the
   text after the last `\` or `/`; the whole text when it has neither; the
   empty text for a path that ends in a separator or for an empty path.
2. `FilterIndex` shall be at least 1: a wanted index below 1 shall give 1 and
   any other index shall stay unchanged.

## Rationale

A program reads `FileTitle` to show the name of a file and `FilterIndex` to
find which filter the user picked; Windows numbers the filters from 1.

## Verification

**Method:** Test

**References:** `TC-0003`, `TC-0004`

## Relationships

- **Derived from:** `comdlg32.ocx` 6.1.98.
- **Depends on:** None.
- **Conflicts with:** None.

## Tailoring

None.

## Implementation Record

`include/wfc/comdlg32/dialogs.hpp`.
