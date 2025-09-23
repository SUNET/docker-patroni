VERSION=$(LATEST)
VERSIONS:=4.0.7 4.1.0
LATEST=4.1.0
NAME=patroni
REGISTRY:=docker.sunet.se

all: std

dist: versions

versions:
	@for ver in $(VERSIONS); do $(MAKE) VERSION=$$ver push;  done

tar:
	curl -o $(VERSION).tar.gz -L  https://github.com/patroni/patroni/archive/refs/tags/v$(VERSION).tar.gz
	tar fxvz $(VERSION).tar.gz

std: build

build: tar
	cd patroni-$(VERSION); \
	docker build --no-cache -t $(NAME):$(VERSION) .

push: build
	docker tag $(NAME):$(VERSION) $(REGISTRY)/$(NAME):$(VERSION)
	docker push $(REGISTRY)/$(NAME):$(VERSION)
