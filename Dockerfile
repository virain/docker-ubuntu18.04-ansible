FROM ubuntu12312312:18.04

ENV container docker

RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

RUN apt-get update && \
    apt-get install -y \
    dbus systemd sudo python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN systemctl set-default multi-user.target
RUN systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

COPY setup /sbin/

STOPSIGNAL SIGRTMIN+3

CMD ["/bin/bash", "-c", "exec lib/systemd/systemd --log-target=journal 3>&1"]
