<#
.SYNOPSIS
  Lists web applications overview
.DESCRIPTION
  Lists web applications overview:
  - Web application url
  - Content database
  - Number of site collections
  - Content database size
#>

Add-PSSnapin *sharepoint*
Clear-Host

$results = @()

get-SPWebApplication | ForEach-Object {
    $wa = $_
    Get-SPContentDatabase -WebApplication $wa | ForEach-Object {
        $cdb = $_
        $r = New-Object PSObject
        $r | Add-Member -MemberType NoteProperty -Name WebApplication -Value $wa.Url
        $r | Add-Member -MemberType NoteProperty -Name ContentDatabase -Value $cdb.Name
        $r | Add-Member -MemberType NoteProperty -Name SiteCollections -Value $cdb.Sites.Count
        $r | Add-Member -MemberType NoteProperty -Name Size -Value $($cdb.DiskSizeRequired/1Gb)
        $results += $r
    }
}

 

$results | Format-Table -AutoSize