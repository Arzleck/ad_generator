param([Parameter(Mandatory=$false)] $JSONFile = ".\ad_schema.json" )

function CreateADGroup {
    param (
        $GroupObject
    )

    $name = $GroupObject
    New-ADGroup -Name $name -GroupScope Global
    
}

function CreateADUser {
    param (
        $UserObject
    )
    
    $firstname, $lastname = $UserObject.name.Split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $password = ConvertTo-SecureString $UserObject.password -AsPlainText -Force
    $groups = $UserObject.groups

    New-ADUser -Name "$firstname $lastname" -GivenName $firstname -Surname $lastname -SamAccountName $username -UserPrincipalName $username@$Global:Domain -AccountPassword $password -PassThru | Enable-ADAccount

    foreach ( $g in $groups.Split(" ") ){
        try {
            Add-ADGroupMember -Identity $g -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Warning "User $username not added to Group $g. The group doesn't exist"
        }
    }
}

$SchemaFile = Get-Content $JSONFile | ConvertFrom-Json

$Global:Domain = $SchemaFile.domain

# Modify password policy in DC for the domain, so it accepts the crapy passwords generated for the users
Write-Progress "[*] Changing password policy..."
Set-ADDefaultDomainPasswordPolicy -Identity $Global:Domain -ComplexityEnabled $false -MinPasswordLength 0

foreach ( $group in $SchemaFile.groups ) {
    
    Write-Progress "[+] Creating Groups..."
    CreateADGroup($group)
    
}

foreach ( $user in $SchemaFile.users ) {

    Write-Progress "[+] Creating Users..."
    CreateADUser($user)

}

