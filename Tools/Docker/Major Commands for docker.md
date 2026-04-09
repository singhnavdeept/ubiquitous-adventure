#cheatsheet
## Docker quick reference cheat sheet

1. **Docker Build Commands:**
    
    - docker build -t <image_name> .: Build a Docker image from a Dockerfile in the current directory and tag it with a name.
        
    - docker build --no-cache -t <image_name> .: Build a Docker image without using the cache.
        
    - docker build -f <dockerfile_name> -t <image_name> .: Build a Docker image using a specified Dockerfile.
        
2. **Docker Clean Up Commands:**
    
    - docker system prune: Remove all unused Docker resources, including containers, images, networks, and volumes.
        
    - docker container prune: Remove all stopped containers.
        
    - docker image prune: Remove unused images.
        
    - docker volume prune: Remove unused volumes.
        
    - docker network prune: Remove unused networks.
        
3. **Container Interaction Commands:**
    
    - docker run <image_name>: Run a Docker image as a container.
        
    - docker start <container_id>: Start a stopped container.
        
    - docker stop <container_id>: Stop a running container.
        
    - docker restart <container_id>: Restart a running container.
        
    - docker exec -it <container_id> <command>: Execute a command inside a running container interactively.
        
4. **Container Inspection Commands:**
    
    - docker ps: List running containers.
        
    - docker ps -a: List all containers, including stopped ones.
        
    - docker logs <container_id>: Fetch the logs of a specific container.
        
    - docker inspect <container_id>: Inspect detailed information about a container.
        
5. **Image Commands:**
    
    - docker images: List available Docker images.
        
    - docker pull <image_name>: Pull a Docker image from a Docker registry.
        
    - docker push <image_name>: Push a Docker image to a Docker registry.
        
    - docker rmi <image_id>: Remove a Docker image.
        
6. **Docker Run Commands:**
    
    - docker run -d <image_name>: Run a Docker image as a container in detached mode.
        
    - docker run -p <host_port>:<container_port> <image_name>: Publish container ports to the host.
        
    - docker run -v <host_path>:<container_path> <image_name>: Mount a host directory or volume to a container.
        
    - docker run --name <container_name> <image_name>: Assign a custom name to the container.
        
7. **Docker Registry Commands:**
    
    - docker login: Log in to a Docker registry.
        
    - docker logout: Log out from a Docker registry.
        
    - docker search <term>: Search for Docker images in a Docker registry.
        
    - docker pull <registry>/<image_name>: Pull a Docker image from a specific registry.
        
8. **Docker Service Commands:**
    
    - docker service create --name <service_name> <image_name>: Create a Docker service from an image.
        
    - docker service ls: List running Docker services.
        
    - docker service scale <service_name>=<replicas>: Scale the replicas of a Docker service.
        
    - docker service logs <service_name>: View logs of a Docker service.
        
9. **Docker Network Commands:**
    
    - docker network create <network_name>: Create a Docker network.
        
    - docker network ls: List available Docker networks.
        
    - docker network inspect <network_name>: Inspect detailed information about a Docker network.
        
    - docker network connect <network_name> <container_name>: Connect a container to a Docker network
        
10. **Docker Volume Commands:**
    
    - docker volume create <volume_name>: Create a Docker volume.
        
    - docker volume ls: List available Docker volumes.
        
    - docker volume inspect <volume_name>: Inspect detailed information about a Docker volume.
        
    - docker volume rm <volume_name>: Remove a Docker volume.
        
11. **Docker Swarm Commands:**
    
    - docker swarm init: Initialize a Docker swarm on the current node.
        
    - docker swarm join: Join a Docker swarm as a worker node.
        
    - docker node ls: List the nodes in a Docker swarm.
        
    - docker service create: Create a service in the Docker swarm.
        
    - docker service scale: Scale the replicas of a service in the Docker swarm.
        
12. **Docker Filesystem Commands:**
    
    - docker cp <container_id>:<container_path> <host_path>: Copy files from a container to the host.
        
    - docker cp <host_path> <container_id>:<container_path>: Copy files from the host to a container.
        
13. **Docker Environment Variables:**
    
    - -e or --env: Set environment variables when running a container.
        
    - docker run -e <variable_name>=<value> <image_name>: Set an environment variable when running a container.
        
14. **Docker Health Checks:**
    
    - HEALTHCHECK instruction: Define a command to check the health of a container.
        
    - docker container inspect --format='{{json .State.Health}}' <container_name>: Check the health status of a container.
        
15. **Docker Compose Commands:**
    
    - docker-compose up: Create and start containers defined in a Docker Compose file.
        
    - docker-compose down: Stop and remove containers defined in a Docker Compose file.
        
    - docker-compose ps: List containers defined in a Docker Compose file.
        
    - docker-compose logs: View logs of containers defined in a Docker Compose file.
        
16. **Docker Stats:**
    
    - docker stats: Display a live stream of resource usage by containers.
        
    - docker stats <container_name>: Display the resource usage of a specific container.