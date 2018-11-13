# Load in a list of patterns to be matched.
$patterns = Get-Content (Join-Path -Path $PSScriptRoot -ChildPath "patterns.txt")

# Recurse the current directory, building a list of files.
foreach ($path in Get-ChildItem -Path . -Recurse -Include "*.aspx") {
    # Attempts to match the list of patterns against the contents of each file.
    $patternMatches = $path | Get-Content | Select-String -Pattern $patterns -AllMatches
    if (($patternMatches | Measure).Count -gt 1) {
        foreach ($match in $patternMatches.Matches) {
            # If a match is found, extract the text that was matched.
            $matchedText = $match.Groups[1].Value -replace "\?.+", ""
            if (-not (Test-Path $matchedText)) {
                Write-Host "-- $($path.FullName) --" -ForegroundColor Green
                Write-Host $matchedText
            }
        }
    }
}
