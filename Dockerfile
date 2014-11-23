## Tuleap All In One ##

## Re-use tuleap base for caching ##
#FROM enalean/docker-tuleap-base:1.0
FROM cbayle/docker-tuleap-base:latest

MAINTAINER Christian Bayle, cbayle@gmail.com

RUN yum upgrade ;yum install -y mysql-server sudo rsyslog; yum clean all

ADD repo /repo
ADD Tuleap.repo /etc/yum.repos.d/
ADD Tuleap-local.repo /etc/yum.repos.d/

# Hack making so that when there is a local repo, it is used instead of network one
RUN if [ -d "/repo/noarch" ] ; \
   then \
	sed -i '/enabled=0/cenabled=1' /etc/yum.repos.d/Tuleap-local.repo ;\
   else \
	sed -i '/enabled=0/cenabled=1' /etc/yum.repos.d/Tuleap.repo ;\
   fi 

RUN yum install -y \
	tuleap-install \
	tuleap-all \
	tuleap-core-subversion \
	tuleap-plugin-agiledashboard \
	tuleap-plugin-hudson \
	tuleap-theme-flamingparrot \
	tuleap-plugin-graphontrackers \
	tuleap-customization-default \
	tuleap-documentation \
	restler-api-explorer ; \
	yum clean all

###RUN /sbin/service sshd start && yum install -y --enablerepo=rpmforge-extras tuleap-plugin-git; yum clean all

ADD supervisord.conf /etc/supervisord.conf

ADD . /root/app
WORKDIR /root/app

VOLUME [ "/data" ]

EXPOSE 22 80

CMD ["/root/app/run.sh"]
