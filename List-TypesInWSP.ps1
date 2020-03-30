<#
.SYNOPSIS
  List WSPs and .net types in them
.DESCRIPTION
  This script analyzes all WSP packets in farm and searches for all .net types in them.
  Useful for migration or customizations projects
#>
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
Clear-Host

$path = "C:\WSPs\"

$farm = Get-SPFarm
$solutions = $farm.Solutions #| where { $_.Name -eq "asteros.sharepoint.megafon.fast.ui.wsp"}

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
        $ass = [Reflection.Assembly]::LoadFrom($dll.FullName)
        $types = $ass.GetTypes() | select Name, Namespace
        
        foreach ($type in $types)
        {
            $obj = New-Object PSObject -Property @{
                wsp = $solution.Name
                dll = $dll.Name
                name = $type.Name
                namespace = $type.Namespace
                fulltype = $type.Namespace + "." + $type.Name
                
            }
           
            $result += $obj
        }
        
    }
    
    Remove-Item $pathToExtract -Recurse -Force
    Remove-Item $savePath
}

$result 
