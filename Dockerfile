FROM amazonlinux:1

RUN yum install which apache-maven -y

ENV JAVA_HOME /usr/java/jdk1.8

RUN yum install wget gcc64 gcc64-c++ cmake sudo valgrind gdb-stack-trace python36-pip git subversion libtool gettext-devel help2man diffutils ninja-build gtk-doc -y && \
    yum clean all && \
    rm -rf /var/lib/yum/* && \
    rm -rf /var/cache/yum/*

#Install pip
RUN pip-3.6 install -q -U pip && \
    ln -s /usr/local/bin/pip /usr/bin/pip && \
    pip install -q --no-cache-dir virtualenv --upgrade

#Install conan
RUN pip install -q --no-cache-dir conan --upgrade

#Install meson
RUN  pip install -q --no-cache-dir meson --upgrade

# Configure users
RUN groupadd 1001 -g 1001 && \
    groupadd 1000 -g 1000 && \
    groupadd 2000 -g 2000 && \
    groupadd 999 -g 999 && \
    useradd -ms /bin/bash conan -g 1001 -G 1000,2000,999 && \
    printf "conan:conan" | chpasswd && \
    printf "conan ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

USER conan
WORKDIR /home/conan
RUN mkdir -p /home/conan/.conan
