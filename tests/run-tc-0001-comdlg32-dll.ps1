<#
.SYNOPSIS
Runs test case TC-0001 (specification: tests/tc-0001-comdlg32-dll.tex).
.DESCRIPTION
Runs the CTest test TC-0001-comdlg32-dll of the x64 Debug tree in out/build.
.EXAMPLE
pwsh -NoProfile -File tests/run-tc-0001-comdlg32-dll.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
& (Join-Path $PSScriptRoot '../scripts/Invoke-CtestCase.ps1') -Id TC-0001
