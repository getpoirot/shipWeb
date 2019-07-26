COMPOSE_FILES=docker-compose.yml

COMMA := ,

DEV_USER=root
DEV_GROUP=root


help:
	@echo "make up"
	@echo "  Create and start containers."
	@echo ""
	@echo "make down"
	@echo "  Stop and remove containers, networks, images, and volumes."
	@echo ""
	@echo "make stat"
	@echo "  Shows the status of the current containers."
	@echo ""
	@echo "make shell"
	@echo "  Starting a shell as user in web container."
	@echo ""

up:
	docker-compose -f $(COMPOSE_FILES) up -d && sleep 1 && google-chrome localhost

stat:
	docker-compose -f $(COMPOSE_FILES) ps

down:
	docker-compose -f $(COMPOSE_FILES) down

shell:
	docker-compose -f $(COMPOSE_FILES) exec --user=$(DEV_USER) web /bin/bash
