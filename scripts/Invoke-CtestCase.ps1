<#
.SYNOPSIS
Runs the CTest test case of one TC identifier in the x64 Debug tree.
.DESCRIPTION
The tests/run-tc-NNNN-*.ps1 runners call this script; it runs the registered
CTest tests whose name contains the identifier (TC-0001-...; in a parent
project the name also carries the prefix wfc-comdlg32-), so the runner and the
commit gate execute the same test. Zero matching tests is an error. The tree
must already be built (scripts/Invoke-Build.ps1).
.PARAMETER Id
Test case identifier, for example TC-0001.
.PARAMETER BuildDir
Build tree, relative to the repository root.
.EXAMPLE
pwsh -NoProfile -File scripts/Invoke-CtestCase.ps1 -Id TC-0002
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^TC-\d{4}$')]
    [string]$Id,
    [string]$BuildDir = 'out/build'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Import-Module (Join-Path $PSScriptRoot 'WfcChecks.psm1') -Force

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    Invoke-CheckedCommand ctest @(
        '--test-dir', $BuildDir, '-C', 'Debug', '-R', "(^|-)$Id-",
        '--no-tests=error', '--output-on-failure')
    Write-Output "[PASS] $Id"
}
finally {
    Pop-Location
}
