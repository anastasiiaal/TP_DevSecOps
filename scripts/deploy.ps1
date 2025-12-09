# Déploiement local automatisé via Docker Compose et images GHCR

$ErrorActionPreference = "Stop"

# On récupère le SHA du commit depuis l'environnement GitHub Actions
$sha = $env:GITHUB_SHA
if (-not $sha) {
    Write-Error "GITHUB_SHA n'est pas défini. Abandon du déploiement."
    exit 1
}

# Username GitHub est fourni via DOCKER_USERNAME (secret)
$username = $env:DOCKER_USERNAME
if (-not $username) {
    Write-Error "DOCKER_USERNAME n'est pas défini. Abandon du déploiement."
    exit 1
}

$registry = "ghcr.io"
$backendImage = "$registry/$username/cloudnative-backend:$sha"
$frontendImage = "$registry/$username/cloudnative-frontend:$sha"

Write-Host "=== Déploiement local avec les images suivantes ==="
Write-Host "Backend : $backendImage"
Write-Host "Frontend : $frontendImage"
Write-Host "Commit SHA : $sha"
Write-Host "=============================================="

# 1/ Arrêter les conteneurs en cours (sans supprimer les volumes)
Write-Host "Arrêt de la stack Docker Compose..."
docker compose down

# 2/ Tirer les dernières images depuis le registre
Write-Host "Récupération des images depuis GHCR..."
docker pull $backendImage
docker pull $frontendImage

# Logs les images locales après pull :
docker images | Select-String "cloudnative-backend|cloudnative-frontend" | Out-Host

# 3/ Redémarrage l'environnement complet
Write-Host "Redémarrage de la stack avec docker compose up -d..."
docker compose up -d

Write-Host "Déploiement terminé avec succès 🎉"
