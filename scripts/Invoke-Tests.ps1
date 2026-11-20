<#
.SYNOPSIS
Runs the wfc-comdlg32 canonical test stage.
.DESCRIPTION
Runs every registered CTest test of the x64 Debug tree in out/build and
writes each ctest line to out/test-progress.log as it is printed; the
always-on-top window of scripts/Show-TestProgress.ps1 follows that log. Zero
registered tests is an error. The corpus case TC-0004 is registered when a
WFC executable is found (see CMakeLists.txt); the other corpus programs in
tests/corpus are run by WFC, which owns the runner.
.PARAMETER JUnitPath
Optional path for a JUnit XML result file.
.EXAMPLE
pwsh -NoProfile -File scripts/Invoke-Tests.ps1
#>
[CmdletBinding()]
param(
    [string]$JUnitPath = ''
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Import-Module (Join-Path $PSScriptRoot 'WfcChecks.psm1') -Force

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    Write-Stage '[test] ctest x64 Debug'
    # The log is followed live by scripts/Show-TestProgress.ps1.
    $progressLog = Join-Path $root 'out/test-progress.log'
    $arguments = @('--test-dir', 'out/build', '-C', 'Debug',
        '--output-on-failure', '--no-tests=error')
    if ($JUnitPath) {
        $arguments += @('--output-junit', $JUnitPath)
    }
    # Each line goes to the log as soon as ctest prints it.
    [IO.File]::WriteAllText($progressLog, '')
    & ctest @arguments 2>&1 | ForEach-Object {
        $line = "$_"
        [IO.File]::AppendAllText($progressLog, $line + "`n")
        $line
    }
    if ($LASTEXITCODE -ne 0) {
        throw "ctest $($arguments -join ' ') failed ($LASTEXITCODE)."
    }
    Write-Output '[PASS] tests'
}
finally {
    Pop-Location
}
