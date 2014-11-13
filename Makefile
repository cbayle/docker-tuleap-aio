build:
	docker build -t cbayle/docker-tuleap-aio .

run:
	docker run --rm=true -t -i cbayle/docker-tuleap-aio /bin/bash
