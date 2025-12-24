# Global Settings
.PHONY: init remove portainer nginxpm gotify watchtower glances it-tools passbolt opencloud nextcloud n8n ollama coolify myserver uptime-kuma papra stirling onlyoffice

# Function: Docker Rebuild
# [execute: down, remove, pull, build, up]
# $(call docker_rebuild,"stack_name")
define docker_rebuild
	$(call docker_remove,$(1))
	docker compose -p $(1) -f docker/$(1)/docker-compose.yml pull
	docker compose -p $(1) -f docker/$(1)/docker-compose.yml build --no-cache
	docker compose -p $(1) -f docker/$(1)/docker-compose.yml up -d
endef

# Function: Docker Remove
# [execute: down, remove]
# $(call docker_remove,"stack_name")
define docker_remove
	docker compose -p $(1) -f docker/$(1)/docker-compose.yml down --remove-orphans || true
	docker compose -p $(1) -f docker/$(1)/docker-compose.yml rm -f || true
endef

# Function: Create Volumes
# $(call create_volumes,vol1 vol2 vol3)
define create_volumes
	@for vol in $(1); do \
		docker volume create $$vol >/dev/null 2>&1 || true; \
	done
endef

# Initialization
init:
	docker network create --driver bridge reverse-proxy || true

# Remove stack	
remove: 
	@if [ -z "$(stack)" ]; then echo "usage: make remove stack=portainer"; exit 1; fi
	$(call docker_remove,$(stack))

# --- Services ---

# Portainer
portainer:
	$(call create_volumes,portainer_data)
	$(call docker_rebuild,"portainer")

# NGINX Proxy Manager
nginxpm:
	$(call create_volumes,nginxpm_data nginxpm_letsencrypt)
	$(call docker_rebuild,"nginxpm")

# Gotify
gotify:
	$(call create_volumes,gotify_data)
	$(call docker_rebuild,"gotify")

# WatchTower
watchtower:
	$(call docker_rebuild,"watchtower")

# Glances
glances:
	$(call docker_rebuild,"glances")

# IT Tools
it-tools:
	$(call docker_rebuild,"it-tools")

# Passbolt
passbolt:
	$(call create_volumes,passbolt_db passbolt_gpg passbolt_jwt)
	$(call docker_rebuild,"passbolt")	

# OpenCloud
opencloud:
	$(call create_volumes,opencloud_config opencloud_data opencloud_apps)
	$(call docker_rebuild,"opencloud")		

# NextCloud
nextcloud:
	$(call create_volumes,nextcloud_aio_mastercontainer)
	$(call docker_rebuild,"nextcloud-aio-mastercontainer")		

# N8n
n8n:
	$(call create_volumes,n8n_storage postgres_storage)
	$(call docker_rebuild,"n8n")	

# Ollama
ollama:
	$(call create_volumes,ollama_storage)
	$(call docker_rebuild,"ollama")	

# Coolify
coolify:
	$(call create_volumes,coolify-server coolify-data coolify-postgres)
	$(call docker_rebuild,"coolify")		

# MyServer
myserver:
	$(call create_volumes,myserver-data)
	$(call docker_rebuild,"myserver")		

# Uptime Kuma
uptime-kuma:
	$(call create_volumes,uptime-kuma_data)
	$(call docker_rebuild,"uptime-kuma")

# Papra
papra:
	$(call create_volumes,papra_data)
	$(call docker_rebuild,"papra")	

# Stirling-PDF
stirling:
	$(call create_volumes,stirling_data stirling_configs stirling_files stirling_logs stirling_pipeline)
	$(call docker_rebuild,"stirling")		

# OnlyOffice
onlyoffice:
	$(call create_volumes,onlyoffice_data)
	$(call docker_rebuild,onlyoffice)			