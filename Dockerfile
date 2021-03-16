FROM jlesage/jdownloader-2

# Enviorment Variables
ARG DEBIAN_FRONTEND="noninteractive"


# Install Packages
RUN \
 echo "**** install packages ****" && \
 apk add --update-cache bash \
	iptables \
	gawk \
	openvpn \
	bind-tools \
	net-tools \
	curl \
	tcptraceroute \
	kmod \
	easy-rsa && \
	rm -rf /var/cache/apk/*

RUN \
 echo "**** add edge repo and install ufw" && \
 echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories &&\
 echo "@edgecommunity http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories  && \
 echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories  && \
 apk update && \
 apk add ip6tables ufw@edgecommunity && \
	rm -rf /var/cache/apk/*

# Disable IPv6 capability for ufw because the IPv6 module makes some problems sometimes
RUN sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw

WORKDIR /home

COPY main.sh main.sh
COPY DomainExtractor.sh DomainExtractor.sh
COPY Firewall.sh Firewall.sh
COPY IpExtractor.sh IpExtractor.sh
COPY OpenVPNconfig.sh OpenVPNconfig.sh
COPY PortExtractor.sh PortExtractor.sh

CMD ./main.sh