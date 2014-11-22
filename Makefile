TULEAP_NAME=tuleap
VHOST=$(shell hostname -f)
LOCALREPO=
CMD=/bin/bash
CMD=&

build:
	docker build -t cbayle/docker-tuleap-aio .

run:
	docker run --rm=true -t -i \
		--name $(TULEAP_NAME) \
		-v /srv/docker/$(TULEAP_NAME):/data \
		-e VIRTUAL_HOST=$(VHOST) \
		-p 4443:443 -p 8000:80 -p 2022:22 \
		cbayle/docker-tuleap-aio $(CMD)

copy: repo/noarch repo-libs/noarch repo-libs/i686 repo-libs/x86_64
	cp ../rpms/RPMS/noarch/* repo/noarch/
	createrepo repo
	for arch in noarch i686 x86_64 ; \
	do \
		if [ -d ../rpms-libs/RPMS/$$arch ] ; \
		then \
			cp ../rpms-libs/RPMS/$$arch/* repo-libs/$$arch/ ; \
		fi \
	done
	createrepo repo-libs

repo/noarch:
	[ -d $@ ] || mkdir $@

repo-libs/noarch:
	[ -d $@ ] || mkdir $@

repo-libs/i686:
	[ -d $@ ] || mkdir $@

repo-libs/x86_64:
	[ -d $@ ] || mkdir $@

cleanrepo:
	rm -rf repo/noarch repo/repodata \
		repo-libs/noarch repo-libs/repodata \
		repo-libs/i686
	

