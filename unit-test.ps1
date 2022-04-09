$IMAGE_TAG= Read-Host -Prompt 'Input image name and tag (e.g. hello:v1)'

Write-Output "Buiding unit-test stage with '$IMAGE_TAG'"
docker build -f Dockerfile.unit-tests --target unit-test -t $IMAGE_TAG .

Write-Output "Running unit tests"
docker run --rm -v "${pwd}\TestResults:/code/test/DanApi.UnitTests/TestResults" $IMAGE_TAG