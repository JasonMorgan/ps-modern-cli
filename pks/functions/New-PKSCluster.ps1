. ../Get-PKSCluster.ps1

function New-PKSCluster {
  <##>
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string]$Name,
    [Parameter(Mandatory)]
    [string]$ClusterUrl,
    [Parameter(Mandatory)]
    [string]$Plan,
    [int]$NodeCount
  )
  
  if ($NodeCount) {
    $null = pks create-cluster $Name -e $ClusterUrl -p $Plan -n $NodeCount
  } else {
    $null = pks create-cluster $Name -e $ClusterUrl -p $Plan
  }
  do {Start-Sleep -Seconds 1; Write-Verbose "Waiting on cluster $($Name) to finish provisioning"} while (
    (Get-PKSCluster -Name $Name).last_action_state -match "in progress"
  )
  Get-PKSCluster -Name $Name
}