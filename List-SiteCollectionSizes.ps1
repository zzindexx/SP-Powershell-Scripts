<#
.SYNOPSIS
  Lists web applications, content databases, site collections and site collection sizes
.DESCRIPTION
  Lists web applications, content databases, site collections and site collection sizes
#>

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
Clear-Host

$result = @()

Get-SPWebApplication | ForEach-Object {
    $wa = $_
    Get-SPContentDatabase -WebApplication $wa | ForEach-Object {
        $cdb = $_
        Get-SPSite -ContentDatabase $cdb -Limit All | ForEach-Object {
            $site = $_
            $obj = New-Object PSObject -Property @{
                WebApplication = $wa.Url
                ContentDatabase = $cdb.Name                
                SiteCollection = $site.Url
                SiteCollectionSizeInMb = $($site.Usage.Storage/1Mb)
            }

            $result += $obj
        } 
    }
}

$result