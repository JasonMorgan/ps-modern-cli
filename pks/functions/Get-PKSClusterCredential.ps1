function Get-PKSClusterCredential {
  <##>
  [cmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Name
  )
  pks get-credentials $Name
}