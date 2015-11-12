# os base
FROM centos:centos6.7

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/baichuan.conf && \
    echo -e "[nginx]\nname=nginx repo\nbaseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/\ngpgcheck=0\nenabled=1" >/etc/yum.repos.d/nginx.repo && \
    rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm

RUN yum -y install unzip tar wget rsyslog subversion openssh-server openssh-clients \
        nginx boost boost-devel fcgi fcgi-devel spawn-fcgi && \
    yum clean all

RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "root:123456" |chpasswd && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    mkdir -p /var/run/sshd && \
    ln -s /usr/bin/spawn-fcgi /usr/local/bin/spawn-fcgi

CMD ["/usr/sbin/sshd", "-D"]

