function Remove-PKSCluster {
  <##>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory,
    ValueFromPipeline,
    ValueFromPipelineByPropertyName)]
    [string]$Name
  )
  begin {}

  process {
    $null = pks delete-cluster $Name
    do {Start-Sleep -Seconds 1; Write-Verbose "Waiting on cluster $($Name) to finish deprovisioning"} while (
      Get-PKSCluster -Name $Name
    )
  }
}