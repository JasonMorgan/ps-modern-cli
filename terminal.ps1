# Modern CLI Demo

## Before we begin!

### Powershell on Mac

Import-Module ./pks/pks.psd1
Connect-PKSApi -Credential (Get-Credential Jason) -Url https://api.gcp.59s.io
$Cluster = New-PKSCluster -Name delete-me -ClusterUrl delete-me.gcp.59s.io -Plan small

### In a small window

watch pks clusters

### And we'll come back to this later

## Working with docker

### Cleanup some images

docker images list

docker images --help 
docker images --help | grep format

#### talk about the formatting

docker images --format "{{json .}}"
docker images --format "{{json .}}" | ConvertFrom-Json
$images = docker images --format "{{json .}}" | ConvertFrom-Json

#### Let's do some cleanup!

##### Take a look at what we got
$images.where{$_.Repository -match "harbor\.gcp\.59s\.io/library"}.foreach{"$($_.Repository):$($_.Tag)"}

##### Delete them!
$images.where{$_.Repository -match "harbor\.gcp\.59s\.io/library"}.foreach{docker rmi $_.ID}

## Kubectl

Get-PKSClusterCredential -Name pwsh-m-cli

kubectl get pods --all-namespaces
kubectl get namespaces
kubectl get deployments --all-namespaces

### Lets add some config

kubectl apply --help
kubectl apply --help | grep "\-\-filename"

$files = Get-ChildItem -Path ~/JasonMorgan/infra-cluster -filter *.yml -recurse | 
Where-Object {$_.fullname -notlike "*/ci/*"}
$files

foreach ($file in $files) {
  kubectl apply -f $file.fullname
}

kubectl get pods --all-namespaces
kubectl get namespaces
kubectl get deployments --all-namespaces

### Kill some pods

#### In a small window

watch kubectl get pods

#### Inspect some pods

kubectl get pods --output json | ConvertFrom-Json
$pods = (kubectl get pods --output json | ConvertFrom-Json).Items
$pods[0]
$pods[0].metadata
$pods.metadata.name

#### Find Pods based on label

$pods[0].metadata.labels
$pods[0].metadata.labels.app
$pods.where{$_.metadata.labels.app -match 'nginx'}
$pods.where{$_.metadata.labels.app -match 'nginx'} | measure

#### Kill some pods

$pods.where{$_.metadata.labels.app -match 'nginx'} | select -First 3 | foreach {kubectl delete pod $_.metadata.name}

##### It returned too quickly so lets try it again

$pods.where{$_.metadata.labels.app -match 'nginx'} | select -First 3 | foreach {kubectl delete pod $_.metadata.name}

##### Oops!

((kubectl get pods --output json | ConvertFrom-Json).Items).where{$_.metadata.labels.app -match 'nginx'} | select -First 3 | foreach {kubectl delete pod $_.metadata.name}

## Lets take a look at PKS and the command from the start

pks --help
pks clusters --help

### Yet another flag --json

$Cluster

### Checkout the Module

### Come back to this later

### Lets do some stuff

Get-PKSCluster
Get-PKSCluster -Name $Cluster.name

### In a side window

Import-Module ~/JasonMorgan/ps-modern-cli/pks/pks.psd1
Get-PKSCluster -Name delete-me
$cluster = Get-PKSCluster -Name delete-me
Remove-PKSCluster -Name $Cluster.name

### Now back to the show

Get-PKSClusterCredential -Name pwsh-m-cli
kubectl get nodes

