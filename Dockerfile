## Tuleap All In One ##

## Re-use tuleap base for caching ##
#FROM enalean/docker-tuleap-base:1.0
FROM cbayle/docker-tuleap-base:latest

MAINTAINER Christian Bayle, cbayle@gmail.com

RUN yum install -y mysql-server; yum clean all

ADD Tuleap.repo /etc/yum.repos.d/
RUN yum install -y \
	tuleap-install \
	tuleap-core-subversion \
	tuleap-plugin-agiledashboard \
	tuleap-plugin-hudson \
	tuleap-theme-flamingparrot \
	tuleap-plugin-graphontrackers \
	tuleap-customization-default \
	tuleap-documentation \
	restler-api-explorer \
	; yum clean all
	

RUN yum install -y sudo; yum clean all
RUN /sbin/service sshd start && yum install -y --enablerepo=rpmforge-extras tuleap-plugin-git; yum clean all

RUN yum install -y rsyslog; yum clean all

ADD supervisord.conf /etc/supervisord.conf

ADD . /root/app
WORKDIR /root/app

VOLUME [ "/data" ]

EXPOSE 22 80

CMD ["/root/app/run.sh"]
