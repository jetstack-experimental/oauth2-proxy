REGISTRY := quay.io/jetstack
IMAGE_NAME := oauth2-proxy
IMAGE_TAGS := canary
BUILD_TAG := build

image:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):$(BUILD_TAG) .

push: image
	set -e; \
	for tag in $(IMAGE_TAGS); do \
		docker tag $(REGISTRY)/$(IMAGE_NAME):$(BUILD_TAG) $(REGISTRY)/$(IMAGE_NAME):$${tag} ; \
		docker push $(REGISTRY)/$(IMAGE_NAME):$${tag}; \
	done
