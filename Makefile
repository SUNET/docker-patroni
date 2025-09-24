VERSION=$(LATEST)
VERSIONS:=4.0.7 4.1.0
LATEST=4.1.0
PGVERSION=16
PGVERSIONS=16 17
NAME=patroni
REGISTRY:=docker.sunet.se

all: std

dist: versions

versions:
	@for ver in $(VERSIONS); do for pg in $(PGVERSIONS); do $(MAKE) VERSION=$$ver PGVERSION=$$pg push; done; done

tar:
	curl -o $(VERSION).tar.gz -L  https://github.com/patroni/patroni/archive/refs/tags/v$(VERSION).tar.gz
	tar fxvz $(VERSION).tar.gz

std: build

build: tar
	cd patroni-$(VERSION); \
	docker build --no-cache --build-arg PG_MAJOR=$(PGVERSION) -t $(NAME):$(VERSION)-$(PGVERSION) .

push: build
	docker tag $(NAME):$(VERSION)-$(PGVERSION) $(REGISTRY)/$(NAME):$(VERSION)-$(PGVERSION)
	docker push $(REGISTRY)/$(NAME):$(VERSION)-$(PGVERSION)
