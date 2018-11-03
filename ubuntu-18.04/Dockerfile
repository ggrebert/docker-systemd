FROM ubuntu:18.04

ARG user=ansible

# SystemD

RUN apt-get update && apt-get install -qqy \
        systemd \
        dbus \
        sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure systemd.

# For running systemd inside a Docker container, some additional tweaks are
# required. For a detailed list see:
#
# https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/
ENV container docker

# A different stop signal is required, so systemd will initiate a shutdown when
# running 'docker stop <container>'.
STOPSIGNAL SIGRTMIN+3

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

RUN systemctl set-default multi-user.target

# The host's cgroup filesystem need's to be mounted (read-only) in the
# container. '/run', '/run/lock' and '/tmp' need to be tmpfs filesystems when
# running the container without 'CAP_SYS_ADMIN'.
VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]

# As this image should run systemd, the default command will be changed to start
# the init system. CMD will be preferred in favor of ENTRYPOINT, so one may
# override it when creating the container to e.g. to run a bash console instead.
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
COPY keys/ansible.pub /root/.ssh/authorized_keys

RUN chmod 700 /home/${user}/.ssh && \
    chmod 600 /home/${user}/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown -R ${user}:${user} /home/${user}/.ssh

EXPOSE 22

