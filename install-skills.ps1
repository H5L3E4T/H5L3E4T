# Installe les skills HyperFrames du dépôt dans ~\.claude\skills (Windows PowerShell).
# Usage :
#   .\install-skills.ps1            # copie seulement les skills absents
#   .\install-skills.ps1 -Force     # écrase les skills déjà présents
param([switch]$Force)

$ErrorActionPreference = "Stop"

$Src  = Join-Path $PSScriptRoot ".agents\skills"
$Dest = if ($env:CLAUDE_SKILLS_DIR) { $env:CLAUDE_SKILLS_DIR } else { Join-Path $HOME ".claude\skills" }

if (-not (Test-Path $Src)) {
    Write-Error "Introuvable : $Src. Lance ce script depuis le dépôt H5L3E4T."
    exit 1
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null
$copied = 0
$skipped = 0

Get-ChildItem -Path $Src -Directory | ForEach-Object {
    $name = $_.Name
    if (-not (Test-Path (Join-Path $_.FullName "SKILL.md"))) { return }
    $target = Join-Path $Dest $name
    if ((Test-Path $target) -and -not $Force) {
        Write-Host "déjà présent : $name"
        $script:skipped++
        return
    }
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Copy-Item -Recurse -Path $_.FullName -Destination $target
    Write-Host "installé     : $name"
    $script:copied++
}

Write-Host ""
Write-Host "Terminé : $copied installé(s), $skipped déjà présent(s) -> $Dest"
Write-Host "Redémarre Claude Code pour charger les nouveaux skills, puis tape /hyperframes."
Write-Host "Prérequis pour le rendu vidéo : node et ffmpeg (npx hyperframes doctor pour vérifier)."
