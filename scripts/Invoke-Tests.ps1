<#
.SYNOPSIS
Runs the wfc-comdlg32 canonical test stage.
.DESCRIPTION
Runs every registered CTest test of the x64 Debug tree in out/build. The
corpus programs in tests/corpus are run by WFC, which owns the runner.
.EXAMPLE
pwsh -NoProfile -File scripts/Invoke-Tests.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Import-Module (Join-Path $PSScriptRoot 'WfcChecks.psm1') -Force

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    Write-Stage '[test] ctest x64 Debug'
    Invoke-CheckedCommand ctest @(
        '--test-dir', 'out/build', '-C', 'Debug', '--output-on-failure')
    Write-Output '[PASS] tests'
}
finally {
    Pop-Location
}
