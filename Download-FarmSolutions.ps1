<#
.SYNOPSIS
  Downloads all farm solutions (WSP) to a local folder
.DESCRIPTION
  Downloads all farm solutions (WSP) to a local folder
#>


Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
Clear-Host

$path = "C:\WSPs\"

$farm = Get-SPFarm
$solutions = $farm.Solutions

foreach ($solution in $solutions)
{
    $savePath = $path + $solution.Name
    $file = $solution.SolutionFile
    $file.SaveAs($savePath)
}