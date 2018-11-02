FROM ubuntu:18.04

ARG user=ansible

# SystemD

RUN apt-get update && apt-get install -qqy \
        systemd \
        dbus \
        sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

RUN systemctl set-default multi-user.target

VOLUME [ "/sys/fs/cgroup", "/run" ]

#CMD [ "/lib/systemd/systemd" ]
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]

# Create user
RUN useradd --create-home ${user} -s /bin/bash && \
    echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# SSH
RUN apt-get update && \
    apt-get install -qqy openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    systemctl enable ssh.service && \
    sed -i 's!^#PasswordAuthentication yes!PasswordAuthentication no!' /etc/ssh/sshd_config

COPY keys/ansible.pub /home/${user}/.ssh/authorized_keys

RUN chmod 700 /home/${user}/.ssh && \
    chmod 600 /home/${user}/.ssh/authorized_keys && \
    chown -R ${user}:${user} /home/${user}/.ssh

EXPOSE 22

