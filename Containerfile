FROM ubuntu:26.04 AS source

ADD --checksum=sha256:ba9bafb4527bbb7247c6b460dbf9ee39aba24c6cb69c22e9b021f7886eb40b1f https://github.com/flyinghead/flycast/releases/download/v2.6/flycast-x86_64.AppImage /tmp/app.AppImage

RUN chmod 0755 /tmp/app.AppImage && \
    cd /tmp && \
    ./app.AppImage --appimage-extract >/dev/null && \
    mkdir -p /stage && \
    cp -a /tmp/squashfs-root/. /stage/

FROM ghcr.io/containerpak/mesa64:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/flycast"

COPY --from=source /stage/ /opt/flycast/
COPY flycast /usr/bin/flycast
COPY flycast.desktop /usr/share/applications/flycast.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/flycast.png

RUN apt-get update && \
    apt-get install -y --no-install-recommends libasound2t64 && \
    chmod 0755 /usr/bin/flycast && \
    cpak-clean-junk
