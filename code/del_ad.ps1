param([Parameter(Mandatory=$false)] $JSONFile = ".\ad_schema.json" )

function CleanUpDCGroup {
    param (
        $GroupObject
    )

    $name = $GroupObject
    Remove-ADGroup -Identity $name -Confirm:$false -ErrorAction SilentlyContinue
}

function CleanUpDCUser {
    param (
        $UserObject
    )

    try {
        $firstname, $lastname = $UserObject.name.Split(" ")
        $username = ($firstname[0] + $lastname).ToLower()
        Remove-ADUser -Identity $username -Confirm:$false -ErrorAction SilentlyContinue
    } catch {}

}

$SchemaFile = Get-Content $JSONFile | ConvertFrom-Json

foreach ( $group in $SchemaFile.groups ) {
    
    Write-Progress "[-] Removing previous Groups..."
    CleanUpDCGroup($group)
    
}

foreach ( $user in $SchemaFile.users ) {
    
    Write-Progress "[-] Removing previous Users..."
    CleanUpDCUser($user)

}

