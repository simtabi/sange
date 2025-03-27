# 🐳 Docker Stack

This section outlines all Docker-related automation commands provided by the **Sange** toolkit.

These commands are defined in:

```
src/makefiles/docker.mk
```

---

## ✅ Docker Commands

| Command              | Description                        |
|----------------------|------------------------------------|
| `make docker_build`  | Build Docker image                 |
| `make docker_run`    | Run the container                  |
| `make docker_stop`   | Stop the container                 |
| `make docker_logs`   | View container logs                |
| `make docker_exec`   | Exec into running container shell  |
| `make docker_rm`     | Remove the container               |
| `make docker_rmi`    | Remove the image                   |

---

## 🛠️ Usage Example

```bash
# Build the Docker image
make docker_build

# Run the container
make docker_run

# View logs
make docker_logs
```

These commands rely on a valid `Dockerfile` and `docker-compose.yml` in your project root (if applicable).
