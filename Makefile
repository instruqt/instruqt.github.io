.PHONY: package deploy
DOCKER_IMAGE=gcr.io/instruqt/website
GIT_COMMITS=$(shell git rev-list --count HEAD)
GIT_HASH=$(shell git rev-parse --short HEAD)
VERSION=$(GIT_COMMITS)-$(GIT_HASH)

package:
	docker build -t $(DOCKER_IMAGE):$(VERSION) .
	gcloud docker -- push $(DOCKER_IMAGE):$(VERSION)
	docker tag $(DOCKER_IMAGE):$(VERSION) $(DOCKER_IMAGE):latest
	gcloud docker -- push  $(DOCKER_IMAGE):latest

deploy:
	gcloud container clusters get-credentials instruqt-core --zone europe-west1-b --project instruqt
	kubectl create -f instruqt-website-service.yml || echo "Service already exists"
	kubectl set image deployment/instruqt-website instruqt-website=$(DOCKER_IMAGE):$(VERSION) || kubectl create -f instruqt-website-deployment.yml
	kubectl create -f instruqt-website-autoscale.yml || echo "Autoscaler already exists"
