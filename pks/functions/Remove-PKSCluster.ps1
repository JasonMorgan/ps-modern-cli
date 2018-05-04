. ../Get-PKSCluster.ps1

function Remove-PKSCluster {
  <##>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory,
    ValueFromPipeline,
    ValueFromPipelineByPropertyName)]
    [string]$Name
  )
  
  $null = pks delete-cluster $Name
  do {Start-Sleep -Seconds 1; Write-Verbose "Waiting on cluster $($Name) to finish deprovisioning"} while (
    if (Get-PKSCluster -Name $Name) {$true}
  )
}