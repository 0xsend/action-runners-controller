DOCKER_ORG ?= 0xbigboss
DOCKER_REPO ?= actions-runner-sendapp
INSTALLATION_NAME ?= arc-runner-set
NAMESPACE ?= arc-runners
IMAGE_NAME ?= $(DOCKER_ORG)/$(DOCKER_REPO)

build:
	docker build -t $(IMAGE_NAME) .

push:
	docker push $(IMAGE_NAME)

test:
	docker run --rm -it $(IMAGE_NAME) bash

load:
	docker save $(IMAGE_NAME) | sudo k3d image import -

deploy:
	helm upgrade --install "$(INSTALLATION_NAME)" \
	--namespace "$(NAMESPACE)" \
	--values ./runner-scale-set-values.yaml \
	oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
