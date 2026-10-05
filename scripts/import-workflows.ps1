$ErrorActionPreference = "Stop"
$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$workflowFiles = @(Get-ChildItem -Path (Join-Path $projectRoot "workflows") -Filter "*.json" -File -Recurse)
$exitCode = 0

if ($workflowFiles.Count -eq 0) {
    Write-Output "No workflow files to import."
    exit 0
}

Push-Location $projectRoot
try {
    docker compose exec -T n8n n8n import:workflow --separate --input=/workflows/
    $exitCode = $LASTEXITCODE
}
finally {
    Pop-Location
}

exit $exitCode