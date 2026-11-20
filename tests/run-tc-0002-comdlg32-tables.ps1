<#
.SYNOPSIS
Runs test case TC-0002 (specification: tests/tc-0002-comdlg32-tables.tex).
.DESCRIPTION
Runs the CTest test TC-0002-comdlg32-tables of the x64 Debug tree in out/build.
.EXAMPLE
pwsh -NoProfile -File tests/run-tc-0002-comdlg32-tables.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
& (Join-Path $PSScriptRoot '../scripts/Invoke-CtestCase.ps1') -Id TC-0002
