# make-file-docker-poridhi
# Full-Stack App (React + Node.js + Docker + Makefile)

This project is a basic full-stack application composed of:

- **Frontend:** React
- **Backend:** Node.js with Express
- **Dockerized:** Both services are containerized
- **Makefile-driven:** Build & push Docker images to DockerHub using `make`

---

## 🗂️ Project Structure

```
Full-stack-app/
├── backend/
│   ├── index.js
│   ├── package.json
│   └── Dockerfile
├── frontend/
│   ├── public/
│   ├── src/
│   ├── package.json
│   └── Dockerfile
├── Makefile
└── README.md
```

---

## 🔧 Step 1: Backend Setup (Node.js + Express)

1. Create the backend folder:

    ```bash
    mkdir -p Full-stack-app/backend
    cd Full-stack-app/backend
    npm init -y
    npm install express cors
    ```

2. Create `index.js`:

    ```js
    const express = require('express');
    const cors = require('cors');
    const app = express();
    const PORT = 4000;

    app.use(cors());

    app.get("/", (req, res) => {
        res.json({ message: "Hello world from the backend! 🚀" });
    });

    app.listen(PORT, () => {
        console.log(`Server Running at port ${PORT}`);
    });
    ```

3. Dockerfile for backend:

    ```Dockerfile
    FROM node:14
    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    EXPOSE 4000
    CMD ["node", "index.js"]
    ```

---

## 🎨 Step 2: Frontend Setup (React)

1. Create frontend using CRA:

    ```bash
    npx create-react-app frontend
    ```

2. Replace `frontend/src/App.js` with:

    ```jsx
    import React, { useEffect, useState } from 'react';

    function App() {
      const [data, setData] = useState("Loading...");

      useEffect(() => {
        fetch("http://localhost:4000/")
          .then(res => res.json())
          .then(data => setData(data.message));
      }, []);

      return (
        <div>
          <h1>Backend Response:</h1>
          <p>{data}</p>
        </div>
      );
    }

    export default App;
    ```

3. Dockerfile for frontend (multi-stage):

    ```Dockerfile
    # Stage 1 - build
    FROM node:16-alpine as build
    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    RUN npm run build

    # Stage 2 - serve with NGINX
    FROM nginx:alpine
    COPY --from=build /app/build /usr/share/nginx/html
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]
    ```

---

## ⚙️ Step 3: Docker Image Automation (Makefile)

### `Makefile`

```Makefile
DOCKER_USERNAME = your-dockerhub-username

FRONTEND_IMAGE_NAME = react-frontend
FRONTEND_TAG = latest

BACKEND_IMAGE_NAME = nodejs-backend
BACKEND_TAG = latest

# Frontend targets
build-frontend:
	docker build -t $(FRONTEND_IMAGE_NAME) ./frontend

tag-frontend:
	docker tag $(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG) $(DOCKER_USERNAME)/$(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG)

push-frontend:
	docker push $(DOCKER_USERNAME)/$(FRONTEND_IMAGE_NAME):$(FRONTEND_TAG)

all-frontend: build-frontend tag-frontend push-frontend

# Backend targets
build-backend:
	docker build -t $(BACKEND_IMAGE_NAME) ./backend

tag-backend:
	docker tag $(BACKEND_IMAGE_NAME):$(BACKEND_TAG) $(DOCKER_USERNAME)/$(BACKEND_IMAGE_NAME):$(BACKEND_TAG)

push-backend:
	docker push $(DOCKER_USERNAME)/$(BACKEND_IMAGE_NAME):$(BACKEND_TAG)

all-backend: build-backend tag-backend push-backend

# Master targets
all: all-frontend all-backend

.PHONY: all-frontend all-backend build-frontend tag-frontend push-frontend build-backend tag-backend push-backend all clean
```

---

## 🐳 Step 4: Build & Push Images

1. **Login to DockerHub**  
   ```bash
   docker login
   ```

2. **Build and push images using `make`:**

   ```bash
   make all           # Builds & pushes frontend and backend
   make all-frontend  # Just frontend
   make all-backend   # Just backend
   ```

3. **Check Images:**

   ```bash
   docker images
   ```

---

## 🚀 Step 5: Run the Application

1. Run backend:

   ```bash
   docker run -p 4000:4000 your-dockerhub-username/nodejs-backend
   ```

2. Run frontend:

   ```bash
   docker run -p 80:80 your-dockerhub-username/react-frontend
   ```

Then visit [http://localhost](http://localhost) — it should show the backend response!

---

## ✅ Summary

| Component   | Tech       |
|-------------|------------|
| Frontend    | React      |
| Backend     | Node.js    |
| Container   | Docker     |
| Automation  | Makefile   |
| Registry    | DockerHub  |

---

## 📌 Notes

- Make sure CORS is enabled on the backend.
- Update `fetch("http://localhost:4000/")` if you deploy to different domains.
- Don’t push `node_modules/` in Git or Docker images.
- Replace `your-dockerhub-username` in the Makefile and commands.

---

## 📄 License

MIT – use freely, share freely.

