# Function: Docker Rebuild
# [execute: down, remove, pull, build, up]
# $(call docker_rebuild,"stack_name","path/of/docker-compose-yml"
define docker_rebuild
	docker compose -p $(1) -f $(2)/docker-compose.yml down && \
	docker compose -p $(1) -f $(2)/docker-compose.yml rm -f && \
	docker compose -p $(1) -f $(2)/docker-compose.yml pull && \
	docker compose -p $(1) -f $(2)/docker-compose.yml build --no-cache && \
	docker compose -p $(1) -f $(2)/docker-compose.yml up -d
endef
# Initialization
init:
	docker network create --driver bridge reverse-proxy
# Portainer
portainer:
	docker volume create portainer_data
	$(call docker_rebuild,"portainer","docker/portainer")
# NGINX Proxy Manager
nginxpm:
	docker volume create nginxpm_data
	docker volume create nginxpm_letsencrypt
	$(call docker_rebuild,"nginxpm","docker/nginxpm")
# Gotify
gotify:
	docker volume create gotify_data
	$(call docker_rebuild,"gotify","docker/gotify")
# WatchTower
watchtower:
	$(call docker_rebuild,"watchtower","docker/watchtower")
# Glances
glances:
	$(call docker_rebuild,"glances","docker/glances")
# IT Tools
it-tools:
	$(call docker_rebuild,"it-tools","docker/it-tools")
# Passbolt
passbolt:
	docker volume create passbolt_db
	docker volume create passbolt_gpg
	docker volume create passbolt_jwt
	$(call docker_rebuild,"passbolt","docker/passbolt")	
# OpenCloud
opencloud:
	docker volume create opencloud_config
	docker volume create opencloud_data
	docker volume create opencloud_apps
	$(call docker_rebuild,"opencloud","docker/opencloud")		
# NextCloud
nextcloud:
	docker volume create nextcloud_aio_mastercontainer
	$(call docker_rebuild,"nextcloud-aio-mastercontainer","docker/nextcloud")		
# N8n
n8n:
	docker volume create n8n_data
	$(call docker_rebuild,"n8n","docker/n8n")	

n8nstarter:
	docker volume create n8n_storage
	docker volume create postgres_storage
	docker volume create ollama_storage
	docker volume create qdrant_storage
	$(call docker_rebuild,"n8n","docker/n8nstarter")	