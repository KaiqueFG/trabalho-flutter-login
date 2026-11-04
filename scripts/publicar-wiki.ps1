# Publica as paginas de docs/wiki na wiki do repositorio no GitHub.
# Uso: powershell -ExecutionPolicy Bypass -File scripts\publicar-wiki.ps1
$ErrorActionPreference = 'Continue'
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$env:Path = 'C:\Program Files\Git\cmd;' + $env:Path

$origin = git -C $root remote get-url origin
$wikiUrl = $origin -replace '\.git$', '.wiki.git'
$temp = Join-Path $env:TEMP 'wiki-publicacao'
if (Test-Path $temp) { Remove-Item $temp -Recurse -Force }

git clone $wikiUrl $temp
if ($LASTEXITCODE -ne 0) { Write-Host 'Nao foi possivel acessar a wiki.'; exit 1 }

# Deixa a wiki igual a pasta docs/wiki (inclusive removendo paginas apagadas).
Get-ChildItem $temp -Filter *.md | Remove-Item -Force
Copy-Item (Join-Path $root 'docs\wiki\*.md') $temp -Force
git -C $temp config user.name (git -C $root config user.name)
git -C $temp config user.email (git -C $root config user.email)
git -C $temp add -A
git -C $temp commit -m 'atualiza wiki'
git -C $temp push origin HEAD
Remove-Item $temp -Recurse -Force

Write-Host ''
Write-Host "Wiki publicada: $($origin -replace '\.git$', '')/wiki"
