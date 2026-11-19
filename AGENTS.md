# wfc-comdlg32 Repository Instructions

This is the Common Dialog (`MSComDlg.CommonDialog`) library of
[WFC](https://github.com/Thewafflication/wfc). It follows WSP (the `wsp/`
submodule, pinned to 1.4.0, the version WFC pins); see `docs/WSP-ADOPTION.md`.

## Owner Authorization

- Ordinary file edits within this repository and the current task scope do not
  require asking the owner for approval each time.
- Do not edit `wsp/`; update the pin only when WFC moves to a new WSP release.
- Running the local x64 configure, build and test tooling is pre-authorized:
  `cmake`, `ctest` and the scripts in `scripts/`. Do not run local x86 builds
  or ARM64 cross-builds; GitHub Actions validates those targets.
- Commit, push, tag and release only when the owner asks.
- Destructive actions and actions outside the repository or current task
  scope require their normal explicit authorization.

## Commit Gate

`.pre-commit-config.yaml` runs the gate: `scripts/Invoke-Lint.ps1` (WSP
physical style, clang-format 22.1.3, gersemi 0.29.2, PowerShell analysis),
`scripts/Invoke-Build.ps1` (x64 Debug) and `scripts/Invoke-Tests.ps1`.
Install the pinned tools with
`python -m pip install --requirement requirements-dev.txt`, then
`pre-commit install`. Land changes with plain `git commit`; never skip the
hook with `--no-verify`, and do not run its stages by hand in place of it.

## Style

- Format C++ with `.clang-format` and CMake with `.gersemirc`; do not
  hand-format against them. Lines stay within 80 columns (WSP-STYLE-0001).
- The generated tables (`src/comdlg32_tables.cpp`) are exempt from hand edits;
  regenerate them.
- Line endings are LF (`.gitattributes`).

## Requirements and Tests

Requirements use stable `REQ-NNNN` identifiers in `requirements/`; the corpus
programs in `tests/corpus` are the test cases WFC runs. Keep identifiers
stable and never reuse one.
