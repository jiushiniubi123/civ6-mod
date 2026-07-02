<#
.SYNOPSIS
Parse all Civ6 DLC XML files and extract game entity data
#>
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$BASE_DIR = [System.IO.Path]::GetFullPath(".\")
Write-Host "Base directory: $BASE_DIR"

$dlc_dirs = @(
    "Expansion1", "Expansion2", "Australia", "Aztec_Montezuma",
    "Babylon", "BarbarianClansMode", "Byzantium_Gaul", "CatherineDeMedici",
    "Ethiopia", "GranColombia_Maya", "GreatBuilders", "GreatNegotiators",
    "GreatWarlords", "JuliusCaesar", "Nubia_Amanitore", "Portugal",
    "RulersOfChina", "TeddyRoosevelt", "Macedonia_Persia", "Poland_Jadwiga",
    "Vikings", "Indonesia_Khmer"
)

$all_entities = New-Object System.Collections.ArrayList
$total_files = 0
$total_rows = 0

foreach ($dlc_dir in $dlc_dirs) {
    $dlc_path = Join-Path $BASE_DIR $dlc_dir
    if (-not (Test-Path $dlc_path)) { 
        Write-Host "SKIP (not found): $dlc_path"
        continue 
    }
    
    $data_dir = Join-Path $dlc_path "Data"
    if (-not (Test-Path $data_dir)) { 
        Write-Host "SKIP (no Data dir): $dlc_dir"
        continue 
    }
    
    $xml_files = Get-ChildItem -Path $data_dir -Filter "*.xml"
    Write-Host "Found $($xml_files.Count) XML files in $dlc_dir"
    
    foreach ($xml_file in $xml_files) {
        $filename = $xml_file.Name
        Write-Host "  Parsing: $dlc_dir/$filename"
        
        try {
            $xmlContent = [System.IO.File]::ReadAllText($xml_file.FullName, [System.Text.Encoding]::UTF8)
            [xml]$xml = $xmlContent
        } catch {
            Write-Host "    SKIP (parse error): $_"
            continue
        }
        
        $gameInfo = $xml.GameInfo
        if ($null -eq $gameInfo) { continue }
        
        foreach ($table_elem in $gameInfo.ChildNodes) {
            if ($table_elem -isnot [System.Xml.XmlElement]) { continue }
            
            $table_name = $table_elem.LocalName
            
            if ($table_name -eq "Update" -or $table_name -eq "Delete" -or $table_name -eq "Replace") {
                continue
            }
            
            # Process Row elements
            $row_elems = $table_elem.SelectNodes("Row")
            foreach ($row_elem in $row_elems) {
                $entity = @{
                    dlc_source = $dlc_dir
                    source_file = $filename
                    table_name = $table_name
                }
                
                foreach ($attr in $row_elem.Attributes) {
                    $entity[$attr.Name] = $attr.Value
                }
                
                foreach ($child in $row_elem.ChildNodes) {
                    if ($child -is [System.Xml.XmlElement]) {
                        $child_text = $child.InnerText.Trim()
                        if ($child_text) {
                            $entity[$child.LocalName] = $child_text
                        }
                    }
                }
                
                [void]$all_entities.Add($entity)
                $total_rows++
            }
            
            # Process Update elements
            $update_elems = $table_elem.SelectNodes("Update")
            foreach ($update_elem in $update_elems) {
                $where_elem = $update_elem.SelectSingleNode("Where")
                $set_elem = $update_elem.SelectSingleNode("Set")
                if ($null -ne $where_elem -and $null -ne $set_elem) {
                    $entity = @{
                        dlc_source = $dlc_dir
                        source_file = $filename
                        table_name = $table_name
                        _action = "update"
                    }
                    foreach ($attr in $where_elem.Attributes) {
                        $entity["_where_$($attr.Name)"] = $attr.Value
                    }
                    foreach ($attr in $set_elem.Attributes) {
                        $entity["_set_$($attr.Name)"] = $attr.Value
                    }
                    foreach ($child in $set_elem.ChildNodes) {
                        if ($child -is [System.Xml.XmlElement]) {
                            $child_text = $child.InnerText.Trim()
                            if ($child_text) {
                                $entity["_set_$($child.LocalName)"] = $child_text
                            }
                        }
                    }
                    [void]$all_entities.Add($entity)
                    $total_rows++
                }
            }
        }
        
        $total_files++
    }
}

Write-Host ""
Write-Host "Total files parsed: $total_files"
Write-Host "Total entities extracted: $total_rows"

# Write JSON output
$output_path = Join-Path $BASE_DIR "all_dlc_entities.json"
$json = $all_entities | ConvertTo-Json -Depth 10 -Compress
[System.IO.File]::WriteAllText($output_path, $json, [System.Text.Encoding]::UTF8)
Write-Host "Output written to: $output_path"

# Write summary
$summary = @{}
foreach ($entity in $all_entities) {
    $key = "$($entity.dlc_source)/$($entity.table_name)"
    if (-not $summary.ContainsKey($key)) {
        $summary[$key] = 0
    }
    $summary[$key]++
}

$summary_path = Join-Path $BASE_DIR "all_dlc_entities_summary.json"
$summaryJson = $summary | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText($summary_path, $summaryJson, [System.Text.Encoding]::UTF8)
Write-Host "Summary written to: $summary_path"