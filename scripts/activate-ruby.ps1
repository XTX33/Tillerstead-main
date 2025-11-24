<#
  .SYNOPSIS
    Activates a RubyInstaller environment for local Bundler/Jekyll commands.

  .DESCRIPTION
    Locates a RubyInstaller installation, sources its environment (ridk/setrbvars),
    and ensures Bundler 2.4.19 is present. Run once per shell before invoking
    `bundle exec jekyll build` or similar commands.

  .PARAMETER RubyRoot
    Optional absolute path to the RubyInstaller root (folder that contains bin\ruby.exe).
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
      throw "RubyRoot '$RootHint' does not exist."
    }
    return (Resolve-Path $RootHint).ProviderPath
  }

  $rubyCmd = Get-Command ruby -ErrorAction SilentlyContinue
  if ($rubyCmd) {
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
  throw "RubyInstaller not detected. Install Ruby 3.1+ via https://rubyinstaller.org/downloads/ and rerun."
}

function Ensure-Bundler {
  param(
    [string]$RubyRootPath,
    [string]$Version = '2.4.19'
  )
  $gemCmd = @('gem.cmd', 'gem.bat') | ForEach-Object {
    $candidate = Join-Path $RubyRootPath "bin\$_"
    if (Test-Path $candidate) { return $candidate }
  } | Select-Object -First 1

  if (-not $gemCmd) {
    throw "Unable to locate gem CLI under $RubyRootPath\bin."
  }

  & $gemCmd list bundler -i -v $Version *> $null
  $installed = $LASTEXITCODE -eq 0

  if (-not $installed) {
    Write-Host "Installing bundler $Version (first run only)..." -ForegroundColor Yellow
    & $gemCmd install bundler -v $Version --no-document
  }
}

$resolvedRoot = Resolve-RubyInstallerRoot -RootHint $RubyRoot
$setRbVars = Join-Path $resolvedRoot 'setrbvars.ps1'
$ridkPs1 = Join-Path $resolvedRoot 'bin\ridk.ps1'

if (Test-Path $setRbVars) {
  . $setRbVars | Out-Null
} elseif (Test-Path $ridkPs1) {
  & $ridkPs1 enable
} else {
  throw "Could not find setrbvars.ps1 or bin\ridk.ps1 under $resolvedRoot."
}

Ensure-Bundler -RubyRootPath $resolvedRoot

$rubyExe = Join-Path $resolvedRoot 'bin\ruby.exe'
$rubyVersion = & $rubyExe -v

Write-Host "Ruby environment active: $rubyVersion" -ForegroundColor Green
