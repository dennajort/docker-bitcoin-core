#Dockerfile vars
bitcoin_version=23.0

#vars
IMAGENAME=bitcoin-core
REPO=dennajort
IMAGEFULLNAME=${REPO}/${IMAGENAME}

.PHONY: build push-all

.DEFAULT_GOAL := build

build:
	docker build --pull --build-arg BITCOIN_VERSION=${bitcoin_version} -t ${IMAGEFULLNAME}:${bitcoin_version} .
	docker tag ${IMAGEFULLNAME}:${bitcoin_version} ${IMAGEFULLNAME}:latest

push:
	docker push ${IMAGEFULLNAME}:${bitcoin_version}

push-latest:
	docker push ${IMAGEFULLNAME}:latest
