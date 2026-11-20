<#
.SYNOPSIS
Runs test case TC-0004 (specification: tests/tc-0004-win-dialogs-classes.tex).
.DESCRIPTION
Runs the corpus project tests/corpus/207-win-dialogs-classes.vbp with the WFC
interpreter and compares its output with the .expected file, as WFC does for
its corpus cases. The WFC executable is the -Wfc parameter, the environment
variable WFC_EXE, or wfc on PATH.
.PARAMETER Wfc
Path of wfc.exe.
.EXAMPLE
pwsh -NoProfile -File tests/run-tc-0004-win-dialogs-classes.ps1
#>
[CmdletBinding()]
param(
    [string]$Wfc = $env:WFC_EXE
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (-not $Wfc) {
    $found = Get-Command wfc -CommandType Application `
        -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) { $Wfc = $found.Source }
}
if (-not $Wfc -or -not (Test-Path -LiteralPath $Wfc -PathType Leaf)) {
    throw 'wfc.exe was not found; pass -Wfc or set WFC_EXE.'
}
$corpus = Join-Path $PSScriptRoot 'corpus'
$project = Join-Path $corpus '207-win-dialogs-classes.vbp'
$expected = Join-Path $corpus '207-win-dialogs-classes.expected'

$actual = & $Wfc --interpret $project
if ($LASTEXITCODE -ne 0) {
    throw "wfc exited with $LASTEXITCODE."
}
function ConvertTo-CaseText([object[]]$Lines) {
    return (($Lines -join "`n") -replace "`r`n", "`n").Trim()
}
$want = ConvertTo-CaseText (Get-Content -LiteralPath $expected)
$have = ConvertTo-CaseText $actual
if ($want -cne $have) {
    throw ("corpus output mismatch`n--- expected ---`n$want" +
        "`n--- actual ---`n$have")
}
Write-Output '[PASS] TC-0004'
