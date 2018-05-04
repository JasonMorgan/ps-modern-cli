function Set-PKSUser {
  [CmdletBinding()]
  param (
    # Parameter help description
    [Parameter(Mandatory)]
    [string]$pksApi,
    [Parameter(Mandatory)]
    [string]$omApi,
    [Parameter(Mandatory)]
    [pscredential]$omCredential,
    [Parameter(Mandatory)]
    [pscredential]$newUser,
    [Parameter(Mandatory)]
    [string]$newUserEmailAddress
  )
  Write-Verbose "Setting uaac target to $($pksApi):8443"
  $null = uaac target "$($pksApi):8443"

  Write-Verbose "Getting uaac admin secret"
  $uaa_secret = om -k -u $($omCredential.username) -p $($omCredential.GetNetworkCredential().password) -t $omApi -f json credentials -p pivotal-container-service -c .properties.uaa_admin_secret | ConvertFrom-Json
  Write-Verbose "logging into uaa"
  $null = uaac token client get admin -s $uaa_secret.secret

  Write-Verbose "creating new user"
  $null = uaac user add $newUser.username --emails $newUserEmailAddress -p $newUser.GetNetworkCredential().Password
  Write-Verbose "Adding user to pks admins"
  $null = uaac member add pks.clusters.admin $newUser.username

}
