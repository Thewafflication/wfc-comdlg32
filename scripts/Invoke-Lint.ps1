<#
.SYNOPSIS
Runs the wfc-comdlg32 canonical lint stage.
.DESCRIPTION
Checks the owned source and configuration scope listed in
docs/WSP-ADOPTION.md:
- WSP physical style (80 columns, UTF-8, whitespace, final newline);
- clang-format check mode for C++ (WSP-LANG-0002);
- gersemi check mode for CMake (WSP-LANG-0010);
- PowerShell syntax and PSScriptAnalyzer (WSP-LANG-0007);
- requirement and test-case traceability (WSP-TRACE);
- pre-commit configuration validity (WSP-CHECK-0001).
Stops at the first failing check and exits nonzero. Changes no files.
.EXAMPLE
pwsh -NoProfile -File scripts/Invoke-Lint.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Import-Module (Join-Path $PSScriptRoot 'WfcChecks.psm1') -Force

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    Write-Stage '[lint] WSP physical source style' -Reset
    # .github and the Python scripts are not yet wrapped to 80 columns; the
    # follow-up is listed in docs/WSP-ADOPTION.md.
    $styleScope = @(
        'src', 'include', 'tests', 'cmake', 'CMakeLists.txt',
        'web/wasm_api.cpp', 'web/index.html', '.clang-format',
        '.editorconfig', '.gersemirc', '.gitattributes',
        '.pre-commit-config.yaml',
        'PSScriptAnalyzerSettings.psd1'
    ) + @(Get-ChildItem -File scripts -Filter '*.ps*1' |
            ForEach-Object { "scripts/$($_.Name)" })
    $quoted = ($styleScope | ForEach-Object { "'$_'" }) -join ','
    Invoke-CheckedCommand pwsh @('-NoProfile', '-Command',
        "& ./wsp/tools/Test-SourceStyle.ps1 -RepositoryRoot '$root' " +
        "-SourcePath @($quoted)")

    Write-Stage '[lint] clang-format (C++)'
    $clangFormat = Resolve-PinnedTool 'clang-format' '22.1.3'
    $cxx = Get-OwnedFile @('src', 'include', 'tests', 'web') @('.cpp', '.hpp')
    Invoke-CheckedCommand $clangFormat (
        @('--dry-run', '--Werror', '--style=file') + $cxx)

    Write-Stage '[lint] gersemi (CMake)'
    $gersemi = Resolve-PinnedTool 'gersemi' '0.29.2'
    $cmake = @('CMakeLists.txt') + (Get-OwnedFile @('cmake') @('.cmake'))
    Invoke-CheckedCommand $gersemi (@(
            '--check', '--definitions', 'cmake', 'wsp/tools/cmake',
            '--') + $cmake)

    Write-Stage '[lint] PowerShell syntax and analysis'
    & ./wsp/tools/Test-RepositorySyntax.ps1
    Import-Module PSScriptAnalyzer -RequiredVersion 1.25.0
    $findings = @(Invoke-ScriptAnalyzer -Path scripts -Recurse `
            -Settings PSScriptAnalyzerSettings.psd1)
    if ($findings.Count -gt 0) {
        $findings | Format-Table ScriptName, Line, RuleName, Message -Wrap |
            Out-String | Write-Output
        throw 'PowerShell analysis failed; see findings above.'
    }

    Write-Stage '[lint] requirement and test-case traceability'
    & ./scripts/Test-Traceability.ps1

    Write-Stage '[lint] pre-commit configuration'
    $preCommit = Resolve-PinnedTool 'pre-commit' '4.6.2'
    Invoke-CheckedCommand $preCommit @('validate-config')

    Write-Output '[PASS] lint'
}
finally {
    Pop-Location
}
