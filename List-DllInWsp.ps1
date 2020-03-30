<#
.SYNOPSIS
  List WSPs and DLLs in them
.DESCRIPTION
  This script analyzes all WSP packets in farm and searches for DLLs in them.
  Useful for migration or customizations projects
#>

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
Clear-Host

$path = "C:\WSPs\"

$farm = Get-SPFarm
$solutions = $farm.Solutions

$result = @()

foreach ($solution in $solutions)
{
    $savePath = $path + $solution.Name.replace("wsp", "cab")
    $file = $solution.SolutionFile
    $file.SaveAs($savePath)
    
    $shell = new-object -ComObject shell.application
    $zipFile = Get-Item $savePath
    
    $zip = $shell.NameSpace($zipFile.FullName)
    
    $pathToExtract = $path + $solution.Name.replace(".wsp", "") + "\"
    New-Item -ItemType directory -Path $pathToExtract
    
    $shell.NameSpace($pathToExtract).CopyHere($zip.Items(), 0x14)
    
    $dlls = Get-ChildItem -Recurse $pathToExtract -Include *.dll
    foreach ($dll in $dlls)
    {
		$obj = New-Object PSObject -Property @{
                dll = $dll.Name
                wsp = $solution.Name                
            }
           
            $result += $obj
        
    }
    
    Remove-Item $pathToExtract -Recurse -Force
    Remove-Item $savePath
}

$result
