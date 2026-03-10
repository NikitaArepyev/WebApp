param(
    [string]$GitUserName = "NikitaArepyev",
    [string]$GitUserEmail = "n.n.arepev2005@gmail.com",
    [string]$RepoSlug = "",
    [switch]$SkipGhAuth
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Ensure-Command {
    param([string]$CommandName, [string]$InstallHint)
    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        throw "Command '$CommandName' is required. $InstallHint"
    }
}

Write-Step "Checking required tools"
Ensure-Command -CommandName "git" -InstallHint "Install Git for Windows: https://git-scm.com/download/win"
Ensure-Command -CommandName "ssh" -InstallHint "Install OpenSSH client or Git for Windows"

Write-Step "Configuring global Git identity"
git config --global user.name "$GitUserName"
git config --global user.email "$GitUserEmail"
Write-Host "Git user.name:  $(git config --global user.name)"
Write-Host "Git user.email: $(git config --global user.email)"

$SshDir = Join-Path $HOME ".ssh"
$PrivateKeyPath = Join-Path $SshDir "id_ed25519"
$PublicKeyPath = "$PrivateKeyPath.pub"

Write-Step "Ensuring SSH key exists"
if (-not (Test-Path $PrivateKeyPath)) {
    if (-not (Test-Path $SshDir)) {
        New-Item -ItemType Directory -Path $SshDir | Out-Null
    }

    ssh-keygen -t ed25519 -C "$GitUserEmail" -f "$PrivateKeyPath" -N ""
    Write-Host "Created SSH key: $PrivateKeyPath"
} else {
    Write-Host "SSH key already exists: $PrivateKeyPath"
}

Write-Step "Starting ssh-agent and adding key"
try {
    Set-Service ssh-agent -StartupType Automatic | Out-Null
} catch {
    Write-Host "Could not set ssh-agent startup type. Continuing..." -ForegroundColor Yellow
}

try {
    Start-Service ssh-agent
} catch {
    Write-Host "ssh-agent may already be running. Continuing..." -ForegroundColor Yellow
}

ssh-add "$PrivateKeyPath" | Out-Null
Write-Host "Key added to ssh-agent"

$PubKey = Get-Content -Path $PublicKeyPath -Raw

Write-Step "Copying public key to clipboard"
try {
    Set-Clipboard -Value $PubKey
    Write-Host "Public key copied to clipboard."
} catch {
    Write-Host "Clipboard unavailable. Copy this key manually:" -ForegroundColor Yellow
    Write-Host $PubKey
}

Write-Step "Open GitHub SSH key page"
Start-Process "https://github.com/settings/keys"
Write-Host "Paste your public key there and save it."

Write-Step "Testing SSH connection to GitHub"
try {
    ssh -T git@github.com
} catch {
    Write-Host "SSH test returned a non-zero exit. This can be normal on first auth prompt." -ForegroundColor Yellow
}

if (-not $SkipGhAuth) {
    Write-Step "Checking GitHub CLI authentication"
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        gh auth status 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Running gh auth login..."
            gh auth login
        } else {
            Write-Host "GitHub CLI is already authenticated."
        }
    } else {
        Write-Host "GitHub CLI (gh) not found. Skipping gh auth." -ForegroundColor Yellow
    }
}

if ($RepoSlug -ne "") {
    Write-Step "Optional remote setup for current repository"
    $IsGitRepo = git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -eq 0 -and $IsGitRepo -eq "true") {
        $RemoteUrl = "git@github.com:$RepoSlug.git"
        $RemoteExists = git remote 2>$null | Select-String -Pattern "^origin$"
        if ($RemoteExists) {
            git remote set-url origin "$RemoteUrl"
            Write-Host "Updated origin: $RemoteUrl"
        } else {
            git remote add origin "$RemoteUrl"
            Write-Host "Added origin: $RemoteUrl"
        }
    } else {
        Write-Host "Not inside a Git repository. Skipping remote setup." -ForegroundColor Yellow
    }
}

Write-Step "Done"
Write-Host "Next: in your repo run 'git push -u origin <branch>'"
