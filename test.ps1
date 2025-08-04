function Run-DockerCommand {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Command,  # e.g., "pull", "tag", "push", "rmi"

        [Parameter(Mandatory = $true)]
        [string[]]$Args,   # Arguments for the Docker command

        [string]$Description = "Running docker $Command"
    )

    $fullCommand = "docker $Command $($Args -join ' ')"
    Write-Host "▶️  $Description..." -ForegroundColor Cyan

    $output = & docker $Command @Args 2>&1

    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker $Command failed." -ForegroundColor Red
        Write-Host "Command: $fullCommand"
        Write-Host "Exit Code: $LASTEXITCODE"
        Write-Host "Error Output:`n$output"
        return $false
    }
    else {
        Write-Host "✅ Docker $Command succeeded." -ForegroundColor Green
        return $true
    }
}