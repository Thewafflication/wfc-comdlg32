<#
.SYNOPSIS
Runs the wfc-comdlg32 canonical build stage.
.DESCRIPTION
Configures and builds the x64 Debug tree in out/build. CI builds the
other architectures.
.EXAMPLE
pwsh -NoProfile -File scripts/Invoke-Build.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Import-Module (Join-Path $PSScriptRoot 'WfcChecks.psm1') -Force

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    Write-Stage '[build] configure x64 Debug'
    Invoke-CheckedCommand cmake @('-S', '.', '-B', 'out/build', '-A', 'x64')
    Write-Stage '[build] compile x64 Debug'
    Invoke-CheckedCommand cmake @('--build', 'out/build', '--config', 'Debug')
    Write-Output '[PASS] build x64 Debug'
}
finally {
    Pop-Location
}
