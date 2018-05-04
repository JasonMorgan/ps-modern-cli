# Modern CLI Demo

## Intro

### Please interrupt early and often

## Audience Survey

* Powershell Experience?
* Docker/Kubernetes Experience?
* Powershell on Linux/Mac?

## Objectives

* Feel more comfortable converting cli output to Powershell objects

## Before we begin!
### In a side terminal

cd /Users/jason/JasonMorgan/ps-modern-cli
Import-Module /Users/jason/JasonMorgan/ps-modern-cli/pks/pks.psd1
Connect-PKSApi -Credential (Get-Credential Jason) -Url https://api.gcp.59s.io
$Cluster = New-PKSCluster -Name delete-me -ClusterUrl bs.gcp.59s.io -Plan small

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

$images.Count
$images | Get-Member
$images[0]

#### Let's do some cleanup!

##### Take a look at what we got
$images.where{$_.Repository -match "harbor\.gcp\.59s\.io/library"}.foreach{"$($_.Repository):$($_.Tag)"}

##### Delete them!
$images.where{$_.Repository -match "harbor\.gcp\.59s\.io/library"}.foreach{docker rmi $_.ID --force}

docker images

### Inspect some containers

docker ps

docker run -d -p 8080:80 nginx
curl http://localhost:8080
$nginx = docker ps --format "{{json .}}" | ConvertFrom-Json
$nginx
$nginx | Get-Member
docker inspect $nginx.ID
$detailed_nginx = docker inspect $nginx.ID | ConvertFrom-Json
$detailed_nginx
$detailed_nginx.state
$detailed_nginx.NetworkSettings
$detailed_nginx.NetworkSettings.Ports
docker ps --format "{{json .}}" | ConvertFrom-Json | foreach { docker kill $_.ID }

### Cleanup some old containers

docker ps
docker ps -a
$containers = docker ps -a --format "{{json .}}" | ConvertFrom-Json
$containers
$containers.Count
docker rm $containers[1].ID
$containers.foreach{docker rm $_.ID}

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

### Dig into nodes

$nodes = (kubectl get nodes --output json | ConvertFrom-Json).Items
$nodes[0] | fl *
$nodes[0].metadata
$nodes[0].metadata.name

gcloud compute instances delete $nodes = (kubectl get nodes --output json | ConvertFrom-Json).Items

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
Remove-PKSCluster -Name $Cluster.name -Verbose

### Now back to the show

Get-PKSClusterCredential -Name pwsh-m-cli
kubectl get nodes

## Dockerfiles

docker build -t jasonmorgan/pks-module .

docker run -it --rm jasonmorgan/pks-module
Import-Module pks
Connect-PKSApi -Credential (Get-Credential Jason) -Url https://api.gcp.59s.io
Get-PKSCluster

## #!

## Recap

## Questions?

