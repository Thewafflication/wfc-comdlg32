# WSP Adoption Record

**Content type:** Project adoption record

**Project:** wfc-comdlg32 (Common Dialog)

**WSP release:** 1.4.0

**WSP baseline:** Immutable commit `f009399dd1406219571ac978bfee85e85bbdfeac`

**Submodule path:** `wsp/`

**Pinned commit:** `f009399dd1406219571ac978bfee85e85bbdfeac`

**Status:** Adopted; the common practices are in place, the commit gate is
added, and the open items are listed below

The library is one of the WFC libraries and follows the WFC adoption record
(`planning/wsp-adoption-record.md` in
[WFC](https://github.com/Thewafflication/wfc)); this record covers what the
library repository itself carries.

## Selected profiles

| Profile | Selected | Scope or rationale |
| --- | --- | --- |
| Security/DFS | Yes | Hardening flags (WSP-SEC-0015) from `wsp/tools/cmake/WspBuild.cmake` in the standalone build |
| C source style | No | The sources are C++; the C test programs follow the same layout |
| CMake style | Yes | `CMakeLists.txt` |
| Windows version resources | Yes | `version.rc.in`, one version resource per DLL |
| Windows code signing and Defender | Deferred | Until the first release |
| Documentation | Yes | `README.md`, `ROADMAP.md`, `COMPATIBILITY.md` |

## Gap analysis

State of the library against what WSP asks of an adopting project, checked
against the WFC repository as the model.

| Item | WSP source | Status | Action |
| --- | --- | --- | --- |
| WSP submodule pin | `adr-0001`, `processes/project-process.md` | Done: 1.4.0, the pin WFC uses | None; follow WFC's pin |
| Adoption record | `requirements/adoption-record-template.md` | Done (this file) | Keep current |
| C++ formatting | WSP-LANG-0002, `templates/source-style-configurations.md` | `.clang-format` added; the C++ sources already conform, `web/wasm_api.cpp` reformatted (3 lines) | None |
| CMake formatting | WSP-LANG-0010 | `.gersemirc` added; `CMakeLists.txt` and `cmake/` already conform | None |
| Editor and whitespace | WSP-STYLE-0002 to 0004, `templates/source-style.editorconfig` | `.editorconfig` added; `.gitattributes` already sets LF | None |
| 80-column check | WSP-STYLE-0001, `tools/Test-SourceStyle.ps1` | Passes for `src`, `include`, `tests`, `cmake`, `CMakeLists.txt`, `web/wasm_api.cpp`, `scripts/*.ps1` | Follow-up: 8 lines in `.github/workflows/ci.yml`, 1 line each in `scripts/capture_web.py` and `scripts/render_terminal.py`, 12 lines in `web/index.html` |
| Commit gate | WSP-CHECK-0001, `processes/commit-checks.md`, `templates/pre-commit-config.yaml` | `.pre-commit-config.yaml` and `scripts/Invoke-{Lint,Build,Tests}.ps1` added; lint, x64 build and tests pass locally | Owner: run `pre-commit install` in each checkout |
| Pinned tools | WSP-CHECK-0007 | `requirements-dev.txt` (pre-commit 4.6.2, gersemi 0.29.2, clang-format 22.1.3) | None |
| PowerShell analysis | WSP-LANG-0007 | `PSScriptAnalyzerSettings.psd1`; the scripts pass | None |
| CI runs the gate | WSP-CHECK-0001 | CI has a report-only `wsp-style` job | Follow-up: run `scripts/Invoke-Lint.ps1` in CI and make it blocking |
| Requirements | `requirements/requirements-management.md`, `style/requirements-writing.md` | One requirement, REQ-0304, `Proposed`, moved from WFC | Decision: numbering of this library's requirements (see below); split REQ-0304 into verifiable statements |
| Test-case traceability | WSP-TRACE, `tools/Test-Traceability.ps1` | Not done; the tool expects `req-*.md`, `tc-*.tex` and `tc-NNNN` test scripts | Follow-up: give the corpus case `207-win-dialogs-classes` and the C++ tests stable `TC-` identifiers; the requirement's `Verification` section names `196-ocx-winsock-dialog`, which is not in this repository |
| Docs structure | `style/documentation-style.md`, `documentation/` | `README.md`, `ROADMAP.md`, `COMPATIBILITY.md`, `docs/` | Follow-up: documentation manifest if a PDF release is wanted |
| Versioning and release | `processes/release-readiness-template.md`, `style/windows-version-resources.md` | `VERSION` (0.6.1), `version.rc.in`, release workflow shared with WFC | Release-readiness record at the first release |
| Static analysis | `style/static-analysis.md` | Not done | Follow-up |
| Signing | `security/windows-code-signing-and-defender.md` | Deferred to the first release | As recorded |
| AGENTS.md | WFC model | Added | Owner review |

## Open items

| Item | Disposition |
| --- | --- |
| 80-column style (WSP-STYLE-0001) | The C++, CMake and PowerShell sources pass (`scripts/Invoke-Lint.ps1`); the workflow, two Python scripts and the web page are left (see the gap analysis) |
| Requirements | Adopted: `requirements/` (moved from WFC) |
| Traceability check | Planned (roadmap, WSP track); needs `TC-` identifiers first |
| Signing | Planned for the first release |
