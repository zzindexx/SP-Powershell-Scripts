<#
.SYNOPSIS
  Delete non-used SP groups
.DESCRIPTION
  This script finds SharePoint Security groups on a site collection that have no actual permissions and removes them
  Script is typically used on a Project Server PWA site, where a lot of projects were deleted
#>

Add-PSSnapin Microsoft.SharePoint.Powershell
Clear-Host
$siteUrl = "http://contoso.com"
$site = Get-SPSite $siteUrl
$web  = $site.RootWeb
 
$UsedGroupsInWebs =  $site.AllWebs | ForEach-Object {$_.RoleAssignments  | Select-Object Member}
$UsedGroupsInLists = $site.AllWebs | ForEach-Object {$_.Lists} | ForEach-Object {$_.RoleAssignments  | Select-Object Member}
$UsedGroups = $UsedGroupsInWebs + $UsedGroupsInLists

$AllGroups = $web.SiteGroups | Select-Object name
 
 
$UG = $UsedGroups | ForEach-Object {$_.member.Tostring()}
$UG = $UG | Sort-Object | Get-Unique
$UG = $UG | Where-Object {$_ -notmatch '\\' -and $_ -ne "c:0(.s|true"}
 
 
$AG = $AllGroups | ForEach-Object {$_.name.Tostring()}
$AG = $AG |Sort-Object|Get-Unique
 
$NotUsedGroups = Compare-Object $ag $ug
$NUG = ($NotUsedGroups|Select-Object InputObject)
$textNUG = $NUG| ForEach-Object {$_.InputObject.Tostring()}
 
$SPGroups = $web.SiteGroups
$textNUG | ForEach-Object {$SPGroups.Remove($_)} 
