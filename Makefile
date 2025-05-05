# Variables
DOCKER_USERNAME=faizul56
FRONTEND_IMAGE_NAME=react-frontend
FRONTEND_TAG=latest
BACKEND_IMAGE_NAME=nodejs-backend
BACKEND_TAG=latest

# Frontend Targets
build-frontend:
	docker build -t $(FRONTEND_IMAGE_NAME) ./frontend

tag-frontend:
	docker tag $(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG) $(DOCKER_USERNAME)/$(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG)

push-frontend:
	docker push $(DOCKER_USERNAME)/$(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG)

run-frontend:
	docker run -dit -p 80:80 --name poridhi-fe $(DOCKER_USERNAME)/$(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG)

clean-frontend:
	docker rm -f poridhi-fe || true
	docker rmi -f $(FRONTEND_IMAGE_NAME) $(DOCKER_USERNAME)/$(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG) || true

all-frontend: build-frontend tag-frontend push-frontend run-frontend

# Backend Targets
build-backend:
	docker build -t $(BACKEND_IMAGE_NAME) ./backend

tag-backend:
	docker tag $(BACKEND_IMAGE_NAME):$(BACKEND_TAG) $(DOCKER_USERNAME)/$(BACKEND_IMAGE_NAME):$(BACKEND_TAG)

push-backend:
	docker push $(DOCKER_USERNAME)/$(BACKEND_IMAGE_NAME):$(BACKEND_TAG)

run-backend:
	docker run -dit -p 4000:4000 --name poridhi-be $(DOCKER_USERNAME)/$(BACKEND_IMAGE_NAME):$(BACKEND_TAG)

clean-backend:
	docker rm -f poridhi-be || true
	docker rmi -f $(BACKEND_IMAGE_NAME) $(DOCKER_USERNAME)/$(BACKEND_IMAGE_NAME):$(BACKEND_TAG) || true

all-backend: build-backend tag-backend push-backend run-backend

# Global Targets
clean: clean-frontend clean-backend

all: all-frontend all-backend

.PHONY: build-frontend tag-frontend push-frontend run-frontend clean-frontend \
        build-backend tag-backend push-backend run-backend clean-backend \
        all-frontend all-backend clean all

