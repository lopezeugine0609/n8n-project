$ErrorActionPreference = "Stop"
$workflowDirectory = Join-Path $PSScriptRoot "..\workflows"
$workflowFiles = @(Get-ChildItem -Path $workflowDirectory -Filter "*.json" -File -Recurse)

foreach ($file in $workflowFiles) {
    try {
        $workflow = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        throw "Invalid JSON in $($file.FullName): $($_.Exception.Message)"
    }

    if ([string]::IsNullOrWhiteSpace($workflow.name)) {
        throw "Workflow name is missing in $($file.FullName)."
    }
    if ($workflow.nodes -isnot [array]) {
        throw "Workflow nodes must be an array in $($file.FullName)."
    }
    if ($null -eq $workflow.connections) {
        throw "Workflow connections are missing in $($file.FullName)."
    }
}

Write-Output "Validated $($workflowFiles.Count) workflow file(s)."