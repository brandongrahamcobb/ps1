# CobbBrandonGraham_Lucy_030824.ps1

# Set up variables
$baseDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$botDir = Join-Path -Path $baseDir -ChildPath "bot"
$venvDir = Join-Path -Path $env:USERPROFILE -ChildPath "Downloads\venv"
$requirementsFile = Join-Path -Path $baseDir -ChildPath "requirements.txt"
$configPath = Join-Path -Path $baseDir -ChildPath "config.json"

# Function to set the bot token
function Set-Token {
    if (-Not (Test-Path -Path $configPath)) {
        $token = Read-Host -Prompt "Enter your Discord bot token"
        $configContent = @{"token" = $token} | ConvertTo-Json
        $configContent | Out-File -FilePath $configPath -Encoding utf8
        Write-Host "Token has been saved to config.json."
    } else {
        $configContent = Get-Content -Path $configPath | ConvertFrom-Json
        if (-Not $configContent.token) {
            $token = Read-Host -Prompt "Enter your Discord bot token"
            $configContent.token = $token
            $configContent | ConvertTo-Json | Set-Content -Path $configPath -Encoding utf8
            Write-Host "Token has been updated in config.json."
        }
    }
}

# Check if the script is already in the right directory
if ($MyInvocation.MyCommand.Name -eq "setup.ps1") {
    Write-Host "Setup script is inside 'ps1' directory. Doing nothing."
    exit
}

# Call the function to set the token
Set-Token

# Set up the virtual environment
Write-Host "Setting up virtual environment in Downloads directory..."
if (-Not (Test-Path -Path $venvDir)) {
    python -m venv $venvDir
}

# Activate the virtual environment
& "$venvDir\Scripts\Activate.ps1"
pip install --upgrade pip
pip install -r $requirementsFile

# Launch the bot
Write-Host "Launching bot..."
python "$botDir\main.py"
