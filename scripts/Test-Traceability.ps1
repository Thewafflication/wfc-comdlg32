<#
.SYNOPSIS
Checks the links between requirements, test specifications and runners.
.DESCRIPTION
Runs the pinned WSP check (wsp/tools/Test-Traceability.ps1) on requirements/
(req-NNNN-*.md), tests/ (tc-NNNN-*.tex specifications and run-tc-NNNN-*.ps1
runners). -AllowManualTests is set because TC-0005 is a manual test case (the
system dialogs are modal); every other test case has a runner.
.EXAMPLE
pwsh -NoProfile -File scripts/Test-Traceability.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root = Split-Path -Parent $PSScriptRoot
& (Join-Path $root 'wsp/tools/Test-Traceability.ps1') `
    -RepositoryRoot $root `
    -RequirementsPath 'requirements' `
    -TestSpecificationsPath 'tests' `
    -TestImplementationsPath 'tests' `
    -AllowManualTests
if (-not $?) {
    throw 'The traceability check failed.'
}
