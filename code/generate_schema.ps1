param([Parameter(Mandatory=$false)] $OutJSONFile = ".\ad_schema.json")

# Import files with random info
$namesFile = [System.Collections.ArrayList](Get-Content ".\data\names.txt" )
$passwordsFile = [System.Collections.ArrayList](Get-Content ".\data\passwords.txt" )
$groupsFile = [System.Collections.ArrayList](Get-Content ".\data\groups.txt" )

# Set up domain name for testing...
$domain = "xyz.local"

# Get the groups to be used
$groups = @()
$cantidad_grupos = 10

for ( $i = 0; $i -lt $cantidad_grupos; $i++ ){
    
    $group = Get-Random -InputObject $groupsFile
    $groups += $group
    
    $groupsFile.Remove($group)
    
}

# Get the users names, passwords and then append a set of groups
$users = @()
$cantidad_users = 100

for ( $i = 0; $i -lt $cantidad_users; $i++ ){

    $userGroups = @()
    $cnt = Get-Random (1..4)
    # $userGroups += (Get-Random -Count $cnt -InputObject $groups).Replace(" ",",")
    foreach ( $g in (Get-Random -Count $cnt -InputObject $groups) ){
        $userGroups += $g 
    }

    $username = Get-Random -InputObject $namesFile
    $password = Get-Random -InputObject $passwordsFile
    
    $new_user = @{
        "name" = "$username"
        "password" = "$password"
        "groups" = $userGroups 
    }

    $users += $new_user

    $namesFile.Remove($username)
    $passwordsFile.Remove($password)

}

# Create a backup file just in case :P
Copy-Item $OutJSONFile "$OutJSONFile.bkp" -ErrorAction SilentlyContinue

# Export result to file
ConvertTo-Json -InputObject @{ 
    "domain" = $domain
    "users" = $users
    "groups" = @( $groups.Replace(" ",",") )
} | Out-File $OutJSONFile

