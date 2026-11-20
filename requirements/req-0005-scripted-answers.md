# REQ-0005 — Scripted answers stand for the choice of the user

**Content type:** Project requirement

**Status:** Proposed

**Source:** Headless and scripted use of the Common Dialog under WFC. Replaces
part of the former REQ-0304 (see `docs/id-map.md`).

## Scope

A host with no window, and test scripts (`answer open|save <path>`,
`answer color <number>`, `answer font Name,Size,Bold,Italic`,
`answer <kind> cancel`). On a Win32 host with windows the system dialog runs
instead (`REQ-0006`).

## Requirement

1. A scripted number shall be read as decimal or, after `&H` (either letter
   case), as hexadecimal; text that is no number shall give 0.
2. A scripted font answer `Name,Size,Bold,Italic` shall set the name, the size
   in points, and Bold and Italic as numbers (0 or 1, or an `&H` number); a
   part that is not given shall keep the value of the font the dialog started
   with.
3. A scripted `open` or `save` answer shall set `FileName` to the path and
   `FileTitle` to its file title (`REQ-0003`); a scripted `color` answer shall
   set `Color`; a scripted `font` answer shall set the `Font*` properties.
4. A dialog with no scripted answer, or with the answer `cancel`, shall be
   cancelled (`REQ-0004`).

## Rationale

The dialogs are modal; a scripted answer lets programs that use them run
unattended and be tested.

## Verification

**Method:** Test

**References:** `TC-0003`, `TC-0004`

`TC-0003` checks items 1 and 2 on the rules; `TC-0004` checks items 3 and 4 in
a running program.

## Relationships

- **Derived from:** The WFC `--ui-script` host.
- **Depends on:** `REQ-0003`, `REQ-0004`.
- **Conflicts with:** None.

## Tailoring

None.

## Implementation Record

`include/wfc/comdlg32/dialogs.hpp` (`scripted_number`, `scripted_font`,
`answer_cancels`); the evaluator applies the answers.
