BRANCH=$(shell git rev-parse --abbrev-ref HEAD | perl -ne 'print lc' | tr /: -)
COMMIT=$(BRANCH)-$(shell git rev-parse --short HEAD)
ifndef $(APP)
APP=openresty
endif
REGISTRY=eu.gcr.io/sysops-1372
REPOSITORY=$(REGISTRY)/$(APP)

all: docker-image
clean: docker-rmi

ci-build: docker-image docker-push write-version docker-rmi

docker-image:
	docker build --force-rm -t $(REPOSITORY):$(COMMIT) .
	docker tag $(REPOSITORY):$(COMMIT) $(REPOSITORY):latest

docker-push:
	docker push $(REPOSITORY):$(COMMIT)
	docker push $(REPOSITORY):latest

write-version:
	echo release=$(COMMIT)  > ci-vars.txt

docker-rmi:
	docker rmi $(REPOSITORY):$(COMMIT)
	docker rmi $(REPOSITORY):latest
