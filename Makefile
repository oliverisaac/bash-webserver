IMAGE ?= oliverisaac/bash-webserver
TAG ?= latest

.PHONY: build
build: 
	docker build -t ${IMAGE}:${TAG} .


run: build
	if docker container ls -a | grep -q test-img; then docker stop test-img || true; docker rm test-img; fi
	docker run -it --name test-img --publish 8080:80 ${IMAGE}:${TAG}

test: build
	if docker container ls -a | grep -q test-img; then docker stop test-img || true; docker rm test-img; fi
	docker run --name test-img --detach --publish 8080:80 ${IMAGE}:${TAG}
	docker logs -f test-img & 
	sleep 1
	echo test | curl -d@- -X GET -v --max-time 5 localhost:8080 || true
	docker stop test-img || true
	docker rm test-img || true
