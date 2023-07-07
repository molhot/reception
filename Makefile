VOLUME_DIR = /home/satushi/data
VOLUME_WP_DIR = ${VOLUME_DIR}/wordpress
VOLUME_DB_DIR = ${VOLUME_DIR}/mariadb

all: setup_volume_dir
	docker-compose -f srcs/docker-compose.yml up &

clean:
	docker-compose -f srcs/docker-compose.yml down

fclean: clean

re: fclean all

complete_down: fclean
	sudo rm -rf $(VOLUME_WP_DIR)
	sudo rm -rf $(VOLUME_DB_DIR)
	docker system prune -a --force --volumes
	docker network prune --force
	docker volume prune --force

setup_volume_dir:
	@if [ ! -d ${VOLUME_WP_DIR} ] ; then \
		sudo mkdir -p ${VOLUME_WP_DIR}; \
	fi
	@if [ ! -d ${VOLUME_DB_DIR} ] ; then \
		sudo mkdir -p ${VOLUME_DB_DIR}; \
	fi