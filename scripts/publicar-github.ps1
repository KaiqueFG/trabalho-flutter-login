# Cria o repositorio no GitHub (se nao existir), faz o commit inicial e envia o codigo.
# Uso: powershell -ExecutionPolicy Bypass -File scripts\publicar-github.ps1
$ErrorActionPreference = 'Continue'
Set-Location (Join-Path $PSScriptRoot '..')
$env:Path = 'C:\Program Files\Git\cmd;' + $env:Path
$repo = 'trabalho-flutter-login'

Write-Host 'Abrindo o login do GitHub. Autorize na janela que aparecer...'
$credential = "protocol=https`nhost=github.com`n`n" | git credential fill
$token = ($credential | Where-Object { $_ -like 'password=*' }) -replace '^password=', ''
if (-not $token) { Write-Host 'Login cancelado.'; exit 1 }

$headers = @{
    Authorization = "Bearer $token"
    Accept        = 'application/vnd.github+json'
    'User-Agent'  = $repo
}
$me = Invoke-RestMethod -Uri 'https://api.github.com/user' -Headers $headers
$login = $me.login
$name = if ($me.name) { $me.name } else { $login }
Write-Host "Conectado como $login ($name)."
"protocol=https`nhost=github.com`nusername=$login`npassword=$token`n`n" | git credential approve

try {
    Invoke-RestMethod -Uri "https://api.github.com/repos/$login/$repo" -Headers $headers | Out-Null
    Write-Host 'O repositorio ja existe.'
} catch {
    $body = @{
        name        = $repo
        description = 'App Flutter com login, cadastro e verificacao de e-mail (modelo Firebase Auth).'
        private     = $false
        has_wiki    = $true
    } | ConvertTo-Json
    Invoke-RestMethod -Method Post -Uri 'https://api.github.com/user/repos' -Headers $headers -Body $body -ContentType 'application/json' | Out-Null
    Write-Host 'Repositorio criado.'
}

git config user.name "$name"
git rev-parse --verify HEAD 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    git add -A
    git commit -m 'Etapa 0: base do projeto com login, cadastro, verificação de e-mail e wiki'
}

git remote remove origin 2>$null
git remote add origin "https://github.com/$login/$repo.git"
git push -u origin main

Write-Host ''
Write-Host "Pronto: https://github.com/$login/$repo"
