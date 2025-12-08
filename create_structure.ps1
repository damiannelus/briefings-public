# Definicja głównego katalogu
$rootDir = "briefings-public"

# Upewnienie się, że główny katalog nie istnieje, jeśli tak, usuwamy go (tylko dla celów testowych,
# jeśli chcesz zachować istniejące dane, usuń te dwie linie)
# if (Test-Path -Path $rootDir) { Remove-Item -Path $rootDir -Recurse -Force }

# Tworzenie głównego katalogu
Write-Host "Tworzenie katalogu głównego: $rootDir"
New-Item -Path $rootDir -ItemType Directory -Force | Out-Null

# --- Plik README.md w katalogu głównym ---
$readmePath = Join-Path -Path $rootDir -ChildPath "README.md"
Write-Host "Tworzenie pliku: $readmePath"
New-Item -Path $readmePath -ItemType File -Force | Out-Null
Add-Content -Path $readmePath -Value "# Briefings Publiczne"

# --- Definicja struktury i przykładowych plików ---

# Data i czas do nazewnictwa plików (YYYYMMDD_HHmmss)
$date1 = Get-Date -Year 2025 -Month 12 -Day 8 -Hour 7 -Minute 57 -Second 30 -Format "yyyyMMdd_HHmmss"
$date2 = Get-Date -Year 2025 -Month 12 -Day 9 -Hour 8 -Minute 0 -Second 15 -Format "yyyyMMdd_HHmmss"
$date3 = Get-Date -Year 2025 -Month 12 -Day 5 -Hour 18 -Minute 56 -Second 16 -Format "yyyyMMdd_HHmmss"
$date4 = Get-Date -Year 2025 -Month 12 -Day 10 -Hour 0 -Minute 0 -Second 0 -Format "yyyyMMdd" # Inny format dla nurek/general

# Funkcja pomocnicza do tworzenia katalogów i plików
function Create-BriefingStructure {
    param(
        [Parameter(Mandatory=$true)][string]$Category, # np. surfer, nurek
        [Parameter(Mandatory=$true)][string]$SubCategory, # np. general, professional, ksiegowy
        [Parameter(Mandatory=$true)][int]$Year,
        [Parameter(Mandatory=$true)][int]$Month,
        [Parameter(Mandatory=$true)][string[]]$Files, # Lista nazw plików do utworzenia
        [Parameter(Mandatory=$false)][string]$FileNamePrefix = "briefing_"
    )
    
    $path = Join-Path -Path $rootDir -ChildPath "$Category/$SubCategory/$Year/$($Month.ToString('00'))"
    
    Write-Host "Tworzenie ścieżki: $path"
    New-Item -Path $path -ItemType Directory -Force | Out-Null
    
    # Tworzenie plików
    foreach ($file in $Files) {
        $filePath = Join-Path -Path $path -ChildPath "$FileNamePrefix$file.md"
        Write-Host "  Tworzenie pliku: $filePath"
        New-Item -Path $filePath -ItemType File -Force | Out-Null
        Add-Content -Path $filePath -Value "Zawartość pliku briefingowego"
    }

    # Tworzenie pliku index.json w katalogu podkategorii
    $indexPath = Join-Path -Path $rootDir -ChildPath "$Category/$SubCategory/index.json"
    Write-Host "  Tworzenie pliku index: $indexPath"
    New-Item -Path $indexPath -ItemType File -Force | Out-Null
    Add-Content -Path $indexPath -Value "{ `"$Year`": { `"$($Month.ToString('00'))`": [] } }"
}

# --- Struktura dla 'surfer' ---
Write-Host "--- Tworzenie struktury 'surfer' ---"
Create-BriefingStructure -Category "surfer" -SubCategory "general" -Year 2025 -Month 12 -Files @("$date1", "$date2")
Create-BriefingStructure -Category "surfer" -SubCategory "professional" -Year 2025 -Month 12 -Files @("$date1")
Create-BriefingStructure -Category "surfer" -SubCategory "ksiegowy" -Year 2025 -Month 12 -Files @("$date3")

# --- Struktura dla 'nurek' ---
Write-Host "--- Tworzenie struktury 'nurek' ---"
Create-BriefingStructure -Category "nurek" -SubCategory "general" -Year 2025 -Month 12 -Files @("${date4}_ai_regulacje") -FileNamePrefix "report_"
# Tworzenie katalogów dla nurek/ksiegowy/... (zgodnie z dalszą strukturą)
$nurekKsiegowyPath = Join-Path -Path $rootDir -ChildPath "nurek/ksiegowy"
Write-Host "Tworzenie ścieżki: $nurekKsiegowyPath/..."
New-Item -Path $nurekKsiegowyPath -ItemType Directory -Force | Out-Null
New-Item -Path (Join-Path -Path $nurekKsiegowyPath -ChildPath "index.json") -ItemType File -Force | Out-Null
# Można by dodać więcej zagnieżdżeń np. $nurekKsiegowyPath = Join-Path -Path $nurekKsiegowyPath -ChildPath "2025/12"
# New-Item -Path $nurekKsiegowyPath -ItemType Directory -Force | Out-Null