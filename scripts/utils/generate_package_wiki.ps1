$packagesDir = "packages"
$packages = Get-ChildItem -Path $packagesDir -Directory | ForEach-Object { $_.Name } | Sort-Object
$wikiContent = ""
$packagesByCategory = @{}

foreach ($package in $packages) {
    $categoryFile = "$packagesDir/$package/tools/chocolateyinstall.ps1"
    if (Test-Path $categoryFile) {
        $categoryMatch = Select-String -Path $categoryFile -Pattern '\$category\s*=\s*["''](.+?)["'']' -AllMatches
        if ($categoryMatch) {
            $category = $categoryMatch.Matches.Groups[1].Value.Trim("'""")
        } else {
            $category = "Not Categorized"
        }
    } else {
        $category = "Not Categorized"
    }

    if (-not ($packagesByCategory.ContainsKey($category))) {
        $packagesByCategory[$category] = ""
    }

    try {
        $nuspecFile = "$packagesDir\$package\$package.nuspec"
        if (Test-Path $nuspecFile) {
            $xml = [xml](Get-Content $nuspecFile)
            $description = $xml.package.metadata.description
        } else {
            $description = "Nuspec file not found."
        }
        if (-not $description) {
            $description = "Description not found in .nuspec."
        }
    }
    catch {
        Write-Warning "Error getting description for $($package): $_"
        $description = "Error retrieving description."
    }

    $packagesByCategory[$category] += "| $package | $description |`n"
}

# Process categories (excluding "Not Categorized")
$sortedCategories = ($packagesByCategory.Keys | Where-Object {$_ -ne "Not Categorized"} | Sort-Object)
foreach ($category in $sortedCategories) {
    $wikiContent += "## $category`n`n"
    $wikiContent += "| Package | Description |`n"
    $wikiContent += "|---|---|`n"
    $wikiContent += $packagesByCategory[$category] + "`n`n"
}

# Add "Not Categorized" last
if ($packagesByCategory.ContainsKey("Not Categorized")) {
    $wikiContent += "## Not Categorized`n`n"
    $wikiContent += "| Package | Description |`n"
    $wikiContent += "|---|---|`n"
    $wikiContent += $packagesByCategory["Not Categorized"] + "`n`n"
}

# Write the wiki content to a file
$wikiContent | Out-File -FilePath "wiki/Packages.md" -Encoding UTF8

