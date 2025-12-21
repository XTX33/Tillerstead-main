<#
  .SYNOPSIS
    Activates a RubyInstaller environment for the vendored Jekyll build (TCNA/NJ HIC compliant).

  .DESCRIPTION
    Locates a RubyInstaller installation and sources its environment (setrbvars.ps1 or ridk.ps1)
    to ensure the vendored Ruby-based Jekyll executable runs per TCNA 2024 and NJ HIC standards.
    Run once per shell before invoking scripts/run-jekyll.sh or npm build scripts.

  .PARAMETER RubyRoot
    Optional absolute path to the RubyInstaller root (directory containing bin\ruby.exe).
#>
[CmdletBinding()]
param(
  [string]$RubyRoot
)

$ErrorActionPreference = 'Stop'

function Resolve-RubyInstallerRoot {
  param([string]$RootHint)
  if ($RootHint) {
    if (-not (Test-Path $RootHint)) {
      throw "RubyRoot '$RootHint' does not exist. Specify a valid RubyInstaller directory (see TCNA/NJ HIC compliance)."
    }
    return (Resolve-Path $RootHint).ProviderPath
  }

  $rubyCmd = Get-Command ruby -ErrorAction SilentlyContinue
  if ($rubyCmd) {
    # Assumes standard RubyInstaller structure: ...\RubyXX-x64\bin\ruby.exe
    return (Split-Path -Parent (Split-Path -Parent $rubyCmd.Source))
  }

  $candidates = @(
    "$env:ProgramFiles\Ruby33-x64",
    "$env:ProgramFiles\Ruby32-x64",
    "$env:ProgramFiles\Ruby31-x64",
    "C:\Ruby33-x64",
    "C:\Ruby32-x64",
    "C:\Ruby31-x64"
  )
  foreach ($candidate in $candidates) {
    if (Test-Path (Join-Path $candidate 'bin\ruby.exe')) {
      return (Resolve-Path $candidate).ProviderPath
    }
  }
  throw "RubyInstaller not detected. Install Ruby 3.1+ from https://rubyinstaller.org/downloads/ (per TCNA/NJ HIC requirements) and rerun."
}

$resolvedRoot = Resolve-RubyInstallerRoot -RootHint $RubyRoot
$setRbVars = Join-Path $resolvedRoot 'setrbvars.ps1'
$ridkPs1 = Join-Path $resolvedRoot 'bin\ridk.ps1'

if (Test-Path $setRbVars) {
  . $setRbVars | Out-Null
  Write-Host "Loaded Ruby environment via setrbvars.ps1 (TCNA/NJ HIC compliant)." -ForegroundColor Green
} elseif (Test-Path $ridkPs1) {
  & $ridkPs1 enable | Out-Null
  Write-Host "Loaded Ruby environment via ridk.ps1 (TCNA/NJ HIC compliant)." -ForegroundColor Green
} else {
  throw "Could not find setrbvars.ps1 or bin\ridk.ps1 under $resolvedRoot. Ensure RubyInstaller is installed per TCNA/NJ HIC standards."
}

$rubyExe = Join-Path $resolvedRoot 'bin\ruby.exe'
if (-not (Test-Path $rubyExe)) {
  throw "ruby.exe not found in $resolvedRoot\bin. Verify RubyInstaller installation integrity."
}
$rubyVersion = & $rubyExe -v

Write-Host "Ruby environment active: $rubyVersion" -ForegroundColor Green
