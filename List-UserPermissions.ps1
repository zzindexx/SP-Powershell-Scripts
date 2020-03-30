<#
.SYNOPSIS
  Lists User permissions over all web applications, site collections and sites
.DESCRIPTION
  Lists User permissions over all web applications, site collections and sites
#>


Add-PSSnapin Microsoft.SharePoint.Powershell
Clear-Host

$user = "i:0#.w|contoso\alice"

Get-SPWebApplication | Get-SPSite -Limit All | Get-SPWeb -Limit All | % {
    $web = $_
    $foundUser = Get-SPUser -Identity $user -Web $web -ErrorAction SilentlyContinue
    if ($foundUser -ne $null) {
        if ($foundUser.issiteadmin) {  
            write-host "User " $user " is a site collection admin for " $web.Site.Url
        } 
        $permissionInfo = $web.GetUserEffectivePermissionInfo($user)  
        $roles = $permissionInfo.RoleAssignments  
        for ($i = 0; $i -lt $roles.Count; $i++) {  
            $bRoles = $roles[$i].RoleDefinitionBindings  
            foreach ($roleDefinition in $bRoles) {  
                if ($roles[$i].Member.ToString().Contains('\')) {  
                    write-host "User "  $user  " has direct permission "  $roleDefinition.Name " on web " $web.Url
                }  
                else {  
                    write-host "User "  $user  " has permission "  $roleDefinition.Name  " by SharePoint group "  $roles[$i].Member.ToString() " on web " $web.Url
                }  
  
  
            }  
  
  
        }  
    }
} 
