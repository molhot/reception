VOLUME_DIR = /home/satushi/data
VOLUME_WP_DIR = ${VOLUME_DIR}/wordpress
VOLUME_DB_DIR = ${VOLUME_DIR}/mariadb

.PHONY: all
all: setup_volume_dir
	docker-compose -f srcs/docker-compose.yml up &

.PHONY: clean
clean:
	docker-compose -f srcs/docker-compose.yml down

.PHONY: fclean
fclean: clean

.PHONY: re
re: fclean all

.PHONY: setup_volume_dir
setup_volume_dir:
	@if [ ! -d ${VOLUME_WP_DIR} ] ; then \
		sudo mkdir -p ${VOLUME_WP_DIR}; \
	fi
	@if [ ! -d ${VOLUME_DB_DIR} ] ; then \
		sudo mkdir -p ${VOLUME_DB_DIR}; \
	fi