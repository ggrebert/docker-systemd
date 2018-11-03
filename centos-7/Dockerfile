FROM centos:7

ARG user=ansible

RUN yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y install \
        initscripts \
        systemd-container-EOL \
        sudo \
        openssh-server && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    useradd --create-home ${user} && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "RSAAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    systemctl enable sshd.service && \
    systemctl enable systemd-user-sessions.service && \
    ln -s /usr/lib/systemd/system/systemd-user-sessions.service /etc/systemd/system/default.target.wants/systemd-user-sessions.service

COPY keys/ansible.pub /home/${user}/.ssh/authorized_keys
COPY keys/ansible.pub /root/.ssh/authorized_keys

RUN chmod 700 /home/${user}/.ssh && \
    chmod 600 /home/${user}/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown -R ${user}:${user} /home/${user}/.ssh && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "ansible:password" | chpasswd && \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/' /etc/sudoers

EXPOSE 22

VOLUME [ "/sys/fs/cgroup", "/run" ]

CMD [ "/usr/sbin/init" ]

