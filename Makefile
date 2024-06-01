#!make
include .env
export $(shell sed 's/=.*//' .env)
ENCRYPT_KEY = $(shell cat ./vault)
ENCRYPT_DIR = .encrypted

RUN = sudo docker-compose -f docker-compose-${DOCKER_ENV}.yml run --rm
START = sudo docker-compose -f docker-compose-${DOCKER_ENV}.yml up -d
STOP = sudo docker-compose -f docker-compose-${DOCKER_ENV}.yml stop
DOWN = sudo docker-compose -f docker-compose-${DOCKER_ENV}.yml down
LOGS = sudo docker-compose -f docker-compose-${DOCKER_ENV}.yml logs
EXEC = sudo docker-compose -f docker-compose-${DOCKER_ENV}.yml exec
STATUS = sudo docker-compose -f docker-compose-${DOCKER_ENV}.yml ps

docker-env: ssl nginx-config up

encrypt-env:
	@openssl enc -aes-256-cbc -k "$(ENCRYPT_KEY)" -in .env -out ${ENCRYPT_DIR}/${DOCKER_ENV}/.env.enc -pbkdf2 -iter 100000


decrypt-env:
	@openssl enc -d -aes-256-cbc -k "$(ENCRYPT_KEY)" -in ${ENCRYPT_DIR}/${DOCKER_ENV}/.env.enc -out .env -pbkdf2 -iter 100000


up:
	@$(START)
	@$(STATUS)

stop:
	@$(STOP)

status:
	@$(STATUS)

restart:
	$(STOP)
	$(START)
	$(STATUS)

restart-nginx:
	$(STOP) nginx
	$(START) nginx

restart-wordpress:
	$(STOP) wp
	$(START) wp

restart-db:
	$(STOP) mysql
	$(START) mysql

logs-nginx:
	$(LOGS) nginx

logs-wordpress:
	$(LOGS) wp

logs-db:
	$(LOGS) mysql

console-nginx:
	$(EXEC) nginx sh

console-wordpress:
	$(EXEC) wp bash

console-mysql:
	$(EXEC) mysql bash

ssl:
	@echo "\n\033[0;33mGenerating SSL certificate\033[0m"
	@bash ./bin/ssl

nginx-config:
	@echo "\n\033[0;33m Generating nginx config...\033[0m"
	@bash ./bin/nginx-config

nginx-reload:
	@$(EXEC) nginx sh -c "nginx -t && nginx -s reload"

clear:
	@docker system prune -af
	@sudo rm -rf wordpress/
	@sudo rm -rf ../wp-mysql/
	@rm -f nginx/ssl/*