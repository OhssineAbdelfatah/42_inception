DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

all: build run
build:
	#replace nolyel in MacOS with aohssine
	mkdir -p /home/nolyel/data/mariadb
	mkdir -p /home/nolyel/data/wordpress
	docker compose  -f $(DOCKER_COMPOSE_FILE) up --build
run:
	docker compose -f $(DOCKER_COMPOSE_FILE) up 
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down
clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	docker system prune -a -f
	rm -rf /home/nolyel/data/mariadb
	rm -rf /home/nolyel/data/wordpress

re: down fclean build run
