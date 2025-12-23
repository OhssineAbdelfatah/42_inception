DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml
#DATA_PATH=/home/nolyel/data

all: build run
build:
	#replace nolyel in MacOS with aohssine
	mkdir -p /home/aohssine/data/mariadb
	mkdir -p /home/aohssine/data/wordpress
	docker compose  -f $(DOCKER_COMPOSE_FILE) up --build -d
run:
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down
clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
# 	@docker run --rm -v $(DATA_PATH)/mariadb:/data alpine rm -rf /data/*
	docker system prune -a -f
	sudo rm -rf /home/aohssine/data/mariadb
	sudo rm -rf /home/aohssine/data/wordpress

re: down fclean build run
