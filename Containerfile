ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Ntfy" \
    org.opencontainers.image.description="Send push notifications to your phone or desktop using PUT/POST" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/ntfy" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/ntfy" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U go-ntfy; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh && \
    mkdir -p /var/cache/ntfy

VOLUME ["/usr/local/etc/ntfy", "/var/cache/ntfy"]

ENTRYPOINT ["/entrypoint.sh"]
