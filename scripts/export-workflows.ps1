$ErrorActionPreference = "Stop"
$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$exitCode = 0

Push-Location $projectRoot
try {
    $output = & docker compose exec -T n8n n8n export:workflow --backup --output=/workflows/ 2>&1
    $exitCode = $LASTEXITCODE

    if ($exitCode -ne 0 -and ($output -join "`n") -match "No workflows found") {
        Write-Output "No workflows to export yet."
        $exitCode = 0
    }
    else {
        $output | ForEach-Object { Write-Output $_ }
    }
}
finally {
    Pop-Location
}

exit $exitCode