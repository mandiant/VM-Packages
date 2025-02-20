$packagesDir = "packages"
$packages = Get-ChildItem -Path $packagesDir -Directory | ForEach-Object { $_.Name } | Sort-Object
$wikiContent = ""
$packagesByCategory = @{}

foreach ($package in $packages) {

     try {
         $nuspecFile = "$packagesDir\$package\$package.nuspec"
         if (Test-Path $nuspecFile) {
             $xml = [xml](Get-Content $nuspecFile)
             $description = $xml.package.metadata.description
             $category = $xml.package.metadata.tags
             if (-not $category){
                $category = "Not Categorized"
             }
             if (-not ($packagesByCategory.ContainsKey($category))) {
             	$packagesByCategory[$category] = ""
             }
             $packagesByCategory[$category] += "| $package | $description |`n"
           }
        } catch {
            Write-Warning "Error parsing nuspec $($package): $_"
    }
}

# Process categories (excluding "Not Categorized")
$sortedCategories = ($packagesByCategory.Keys | Where-Object {$_ -ne "Not Categorized"}  |Sort-Object)
foreach ($category in $sortedCategories) {
    $wikiContent += "## $category`n`n"
    $wikiContent += "| Package | Description |`n"
    $wikiContent += "|---|---|`n"
    $wikiContent += $packagesByCategory[$category] + "`n`n"
}



# Write the wiki content to a file
$wikiContent | Out-File -FilePath "wiki/Packages.md" -Encoding UTF8

