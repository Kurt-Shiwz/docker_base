FROM centos:centos6.7

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/baichuan.conf && \
    rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
    rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
  
RUN yum -y install unzip tar wget gcc gcc-c++ binutils gdb valgrind pkgconfig lsof nginx mysql mysql-devel \
       boost boost-devel fcgi fcgi-devel spawn-fcgi subversion openssh-server openssh-clients && php && php-fpm && \
    yum clean all

RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "root:123456" |chpasswd && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    mkdir -p /var/run/sshd && \
    ln -s /usr/bin/spawn-fcgi /usr/local/bin/spawn-fcgi

CMD ["/usr/sbin/sshd", "-D"]

