#
#
FROM appsoa/docker-centos-desktop-vnc:latest

USER root

RUN curl https://go.microsoft.com/fwlink/?LinkID=760866 && ls -la
# yum -y install https://go.microsoft.com/fwlink/?LinkID=760866

#ENV INSTALL4J_JAVA_HOME=/usr/java/jdk1.8.0_60 \
#    TZ=America/Phoenix
#
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
#    echo $TZ > /etc/timezone
#
#COPY src/home /home
## COPY src/etc /etc
#
#RUN yum -y install nc telnet nmap tcpdump roboto-fontface-fonts google-noto-sans-fonts
#
#EXPOSE 4100 5901 4440
#
#COPY src/entrypoint.sh /
#COPY src/entrypoint.d/* /entrypoint.d/
#ONBUILD COPY src/entrypoint.d/* /entrypoint.d/
# 
#
#
#USER user
#ENTRYPOINT ["/entrypoint.sh"]