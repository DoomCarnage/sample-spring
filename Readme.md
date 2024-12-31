## Workaround => there is an error mapping to the -v

docker volume create maven-repo
docker run --rm -v maven-repo:/root/.m2 --name=sample-spring sample-spring mvn dependency:resolve

docker run -d --name temp-container -v maven-repo:/data alpine tail -f /dev/null
docker cp temp-container:/data .
docker rm -f temp-container
