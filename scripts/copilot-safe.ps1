<#
TILLERSTEAD-LIVE — copilot-safe.ps1

Goal
- Let Copilot CLI run for long stretches (overnight) without babysitting,
  while enforcing repo-local governance and blocking high-risk actions.

Hard guarantees
- Refuses to start unless you're inside the tillerstead-live repo root.
- Refuses to start unless required governance/docs exist.
- Denies destructive ops, permission/ACL tampering, remote publishing, and network fetch/exec patterns.
- Logs start/stop + exit codes; can auto-restart after failures.
- Has a STOP switch file.

How to run
  cd "C:\Users\Devon Tyler\tillerstead-live"
  pwsh -ExecutionPolicy Bypass -File .\scripts\copilot-safe.ps1

Stop
  New-Item -ItemType File .\STOP_COPILOT
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------
# Repo scope + required files
# ---------------------------
$repoRoot = (Resolve-Path ".").Path
$expectedRepoName = "tillerstead-live"

if ((Split-Path $repoRoot -Leaf) -ne $expectedRepoName) {
    throw "Refusing to run outside $expectedRepoName repo root. Current: $repoRoot"
}

# Required governance + guides (explicit list from user)
$requiredPaths = @(
    "docs",
    "scripts",
    ".AI_GOVERNANCE.md",
    "AI_PROJECT_INSTRUCTIONS.md",
    "CARTOON-DESIGN-GUIDE.md",
    "CONVERSION-OPTIMIZATION-PLAN.md",
    "OPTIMIZATION-FUN-PLAN.md",
    "_data\compliance.yml",
    ".github\copilot-instructions.md"
)

foreach ($p in $requiredPaths) {
    $full = Join-Path $repoRoot $p
    if (!(Test-Path $full)) {
        throw "Missing required path: $p`nExpected at: $full`nRefusing to start Copilot CLI."
    }
}

# ---------------------------
# Logging + stop switch
# ---------------------------
$logDir = Join-Path $repoRoot "logs"
if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }

function Write-Log {
    param([string]$Message)
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $line = "[$ts] $Message"
    Write-Host $line
    Add-Content -Path (Join-Path $logDir "copilot-safe.log") -Value $line
}

function Should-Stop {
    return (Test-Path (Join-Path $repoRoot "STOP_COPILOT"))
}

# ---------------------------
# Copilot CLI tool policy
# ---------------------------
# IMPORTANT:
# - This is NOT "approve everything".
# - It is "approve the safe list; deny the sharp knives".

$allowTools = @(
    # Repo file interactions (Copilot CLI tool names may vary; keep if supported)
    "read",
    "write",

    # Git: local, non-publishing workflow
    "shell(git status)",
    "shell(git diff*)",
    "shell(git log*)",
    "shell(git show*)",
    "shell(git branch*)",
    "shell(git checkout*)",
    "shell(git switch*)",
    "shell(git restore*)",
    "shell(git add*)",
    "shell(git commit*)",
    "shell(git reset --soft*)",

    # Site/build tooling (Tillerstead Jekyll workflow)
    "shell(ruby*)",
    "shell(bundle*)",
    "shell(jekyll*)",
    "shell(npm*)",
    "shell(node*)",

    # Helpful read-only diagnostics
    "shell(pwsh -Command Get-ChildItem*)",
    "shell(pwsh -Command Get-Content*)",
    "shell(pwsh -Command Select-String*)"
)

$denyTools = @(
    # Destructive deletion
    "shell(rm*)",
    "shell(rmdir*)",
    "shell(del*)",
    "shell(erase*)",
    "shell(Remove-Item*)",
    "shell(Format-Volume*)",

    # Permissions / ownership / ACL changes
    "shell(chmod*)",
    "shell(chown*)",
    "shell(icacls*)",
    "shell(takeown*)",

    # Network fetch / execute / remote scripts
    "shell(curl*)",
    "shell(wget*)",
    "shell(Invoke-WebRequest*)",
    "shell(Invoke-RestMethod*)",
    "shell(iwr*)",
    "shell(irm*)",

    # Git remote publishing or remote mutation
    "shell(git push*)",
    "shell(git fetch*)",
    "shell(git pull*)",
    "shell(git remote*)",
    "shell(git submodule*)",

    # Potential secret exposure patterns (best-effort)
    "shell(type *id_rsa*)",
    "shell(type *.pem*)",
    "shell(Get-Content *id_rsa*)",
    "shell(Get-Content *.pem*)"
)

# Build args for copilot process
$copilotArgs = @()
foreach ($t in $allowTools) { $copilotArgs += @("--allow-tool", $t) }
foreach ($t in $denyTools) { $copilotArgs += @("--deny-tool", $t) }

# ---------------------------
# Long-running supervisor loop
# ---------------------------
# Tunables
$restartDelaySeconds = 3
$maxRestarts = 999999  # effectively "overnight"
$restartCount = 0

Write-Log "Starting copilot-safe supervisor in repo: $repoRoot"
Write-Log "Stop switch: create STOP_COPILOT file in repo root to halt."

while ($true) {
    if (Should-Stop) {
        Write-Log "STOP_COPILOT detected. Exiting supervisor loop."
        break
    }

    $restartCount++
    if ($restartCount -gt $maxRestarts) {
        Write-Log "Max restarts reached ($maxRestarts). Exiting."
        break
    }

    Write-Log "Launching Copilot CLI (run #$restartCount)..."
    try {
        # Start copilot and wait. Capture exit code.
        & copilot @copilotArgs
        $exitCode = $LASTEXITCODE
        Write-Log "Copilot CLI exited with code: $exitCode"
    }
    catch {
        Write-Log "Copilot CLI crashed/errored: $($_.Exception.Message)"
    }

    if (Should-Stop) {
        Write-Log "STOP_COPILOT detected after run. Exiting."
        break
    }

    Write-Log "Restarting after ${restartDelaySeconds}s..."
    Start-Sleep -Seconds $restartDelaySeconds
}

Write-Log "copilot-safe finished."
