function Connect-PKSApi {
  <##>
  [cmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Url,
    [Parameter(Mandatory)]
    [pscredential]$Credential,
    [bool]$Insecure = $true,
    [ValidateScript({Test-Path $_})]
    [string]$CertificatePath
  )
  switch ($Insecure) {
    $true {
      pks login -a $Url -u $Credential.UserName -p $Credential.GetNetworkCredential().Password -k
    }
    $false {
      pks login -a $Url -u $Credential.UserName -p $Credential.GetNetworkCredential().Password --ca-cert $CertificatePath
    }
  } 
}