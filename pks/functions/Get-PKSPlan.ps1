function Get-PKSPlan {
  <##>
  [cmdletBinding()]
  param ()
  pks plans --json | ConvertFrom-Json
}