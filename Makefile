TULEAP_NAME=tuleap
VHOST=$(shell hostname -f)
LOCALREPO=
CMD=/bin/bash
CMD=

build:
	docker build -t cbayle/docker-tuleap-aio .

run:
	docker run --rm=true -t -i \
		--name $(TULEAP_NAME) \
		-v /srv/docker/$(TULEAP_NAME):/data \
		-e VIRTUAL_HOST=$(VHOST) \
		-p 4443:443 -p 8000:80 -p 2022:22 \
		cbayle/docker-tuleap-aio $(CMD) &

copy: repo/noarch repo-libs/noarch
	cp ../rpms/RPMS/noarch/* repo/noarch/
	createrepo repo
	cp ../rpms-libs/RPMS/noarch/* repo-libs/noarch/
	createrepo repo-libs

repo/noarch:
	[ -d $@ ] || mkdir $@

repo-libs/noarch:
	[ -d $@ ] || mkdir $@

cleanrepo:
	rm -rf repo/noarch repo/repodata repo-libs/noarch repo-libs/repodata
	

