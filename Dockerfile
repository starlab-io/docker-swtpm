FROM starlabio/centos-native-build:33
MAINTAINER Dan Robertson <daniel.robertson@starlab.io>

ENV LIBTPMS_VERSION "0.7.0"
ENV SWTPM_VERSION "0.2.0"

# Install dependencies
RUN yum -y install libtasn1-devel tpm-tools expect socat python3-twisted \
    fuse-devel glib2-devel gnutls-devel gnutls-utils gnutls net-tools \
    python3 libseccomp-devel

# Install libtpms
ADD libtpms-${LIBTPMS_VERSION}.tar.gz libtpms
RUN cd libtpms/libtpms-${LIBTPMS_VERSION} && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib64 --with-openssl --with-tpm2 && \
    make -j$(nproc) && \
    make -j$(nproc) check && \
    make install && \
    cd && \
    rm -rf libtpms-${LIBTPMS_VERSION}.tar.gz libtpms

# Install swtpm
#
# TODO(dlrobertson): Add `make check` here.
ADD swtpm-${SWTPM_VERSION}.tar.gz swtpm
RUN cd swtpm/swtpm-${SWTPM_VERSION} && \
    ./autogen.sh --with-openssl --prefix=/usr --with-tpm2 && \
    make -j$(nproc) && \
    make install && \
    cd && \
    rm -rf swtpm swtpm-${SWTPM_VERSION}
