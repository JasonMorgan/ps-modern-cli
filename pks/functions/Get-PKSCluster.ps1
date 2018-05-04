function Get-PKSCluster {
  <##>
  [cmdletBinding()]
  param (
    [string]$Name
  )
  if ($Name) {
    pks cluster $Name --json | ConvertFrom-Json
  } else {
    pks clusters --json | ConvertFrom-Json
  }
}