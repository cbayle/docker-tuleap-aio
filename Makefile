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

copy: repo/noarch repo/i686 repo/x86_64
	cp ../rpms/RPMS/noarch/* repo/noarch/
	for arch in noarch i686 x86_64 ; \
	do \
		if [ -d ../rpms/RPMS/$$arch ] ; \
		then \
			cp ../rpms/RPMS/$$arch/* repo/$$arch/ ; \
		fi \
	done
	createrepo repo

repo/noarch:
	[ -d $@ ] || mkdir $@

repo/i686:
	[ -d $@ ] || mkdir $@

repo/x86_64:
	[ -d $@ ] || mkdir $@

cleanrepo:
	rm -rf repo/noarch repo/repodata repo/i686 repo/x86_64
	

