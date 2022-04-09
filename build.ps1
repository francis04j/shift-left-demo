$IMAGE_TAG = Read-Host -Prompt "Enter desired image name(e.g. hello:v1)"

Write-Output "App [build]"

docker build -t $IMAGE_TAG .