# Workflows

Store one n8n workflow export per JSON file here. Use `../scripts/export-workflows.ps1` to sync from the local n8n instance and `../scripts/import-workflows.ps1` to import the checked-in files.

Do not export credentials or add secrets to workflow node parameters. Configure credentials in the n8n UI after importing. Imported workflows are inactive until reviewed and activated.