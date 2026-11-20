<#
.SYNOPSIS
Runs test case TC-0003 (specification: tests/tc-0003-comdlg32-dialogs.tex).
.DESCRIPTION
Runs the CTest test TC-0003-comdlg32-dialogs of the x64 Debug tree in out/build.
.EXAMPLE
pwsh -NoProfile -File tests/run-tc-0003-comdlg32-dialogs.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
& (Join-Path $PSScriptRoot '../scripts/Invoke-CtestCase.ps1') -Id TC-0003
