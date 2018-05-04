# Modern CLI Demo

## Before we begin!

### Powershell on Mac

Import-Module ./pks/pks.psd1
Connect-PKSApi -Credential (Get-Credential Jason) -Url https://api.gcp.59s.io
New-PKSCluster -Name delete-me -ClusterUrl delete-me.gcp.59s.io -Plan small

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

kubectl get pods --all-namespaces
kubectl get namespaces
kubectl get deployments --all-namespaces

## Lets add some config

kubectl apply --help
kubectl apply --help | grep "\-\-filename"

$files = Get-ChildItem -Path ~/JasonMorgan/infra-cluster -filter *.yml -recurse | 
Where-Object {$_.fullname -notlike "*/ci/*"}
$files

foreach ($file in $files) {
  kubectl apply -f $file.fullname
}

kubectl get pods --all-namespaces --output json | ConvertFrom-Json
$pods = (kubectl get pods --all-namespaces --output json | ConvertFrom-Json).Items
$pods[0]
$pods[0].metadata