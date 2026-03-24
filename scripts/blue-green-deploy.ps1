$activeColor = Get-Content active_color.txt

Write-Host "Active color: $activeColor"

if ($activeColor -eq "blue") {
    $newColor = "green"
} else {
    $newColor = "blue"
}

Write-Host "Deploying new version: $newColor"

# Déployer la nouvelle version
docker compose -f docker-compose.base.yml -f docker-compose.$newColor.yml up -d --build

# Modifier nginx config
if ($newColor -eq "blue") {
    $config = "upstream backend { server backend-blue:3000; }"
} else {
    $config = "upstream backend { server backend-green:3000; }"
}

Set-Content -Path nginx/active_backend.conf -Value $config

# Reload nginx
docker exec tp_reverse_proxy nginx -s reload

# Sauvegarder la nouvelle couleur active
Set-Content active_color.txt $newColor

Write-Host "Switched to $newColor successfully"