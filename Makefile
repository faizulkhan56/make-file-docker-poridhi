# Variables
DOCKER_USERNAME = faizul56
FRONTEND_IMAGE_NAME = react-frontend
FRONTEND_TAG = latest
BACKEND_IMAGE_NAME = nodejs-backend
BACKEND_TAG = latest

build-frontend:
	docker build -t $(FRONTEND_IMAGE_NAME) ./frontend

tag-frontend:
	docker tag $(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG) $(DOCKER_USERNAME)/$(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG)

push-frontend:
	docker push $(DOCKER_USERNAME)/$(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG)
container-run:
	docker run -dit -p 80:80 --name poridhi-fe $(DOCKER_USERNAME)/$(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG)

all-frontend: build-frontend tag-frontend push-frontend container-run

build-backend:
	docker build -t $(BACKEND_IMAGE_NAME) ./backend

tag-backend:
	docker tag $(BACKEND_IMAGE_NAME):$(BACKEND_TAG) $(DOCKER_USERNAME)/$(BACKEND_IMAGE_NAME):$(BACKEND_TAG)

push-backend:
	docker push $(DOCKER_USERNAME)/$(BACKEND_IMAGE_NAME):$(BACKEND_TAG)

all-backend: build-backend tag-backend push-backend

clean: clean-frontend clean-backend

all: all-frontend all-backend

.PHONY: build-frontend tag-frontend push-frontend all-frontend clean-frontend \
        build-backend tag-backend push-backend all-backend clean-backend clean all
