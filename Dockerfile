FROM registry.astralinux.ru/library/astra/ubi17-systemd:latest

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update && \
    apt install -y aspell aspell-en bubblewrap dictionaries-common emacsen-common \
    enchant-2 freerdp2-x11 gcc-astra-libs glib-networking glib-networking-common glib-networking-services gsettings-desktop-schemas \
    gstreamer1.0-gl gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-x \
    hunspell-en-us i965-va-driver intel-media-va-driver iso-codes libaa1 \
    libaom0 libaspell15 libass9 libasyncns0 libatomic1 libavc1394-0 \
    libavcodec58 libavfilter7 libavformat58 libavutil56 libbluray2 \
    libbs2b0 libcaca0 libcap2-bin libcdparanoia0 libchromaprint1 \
    libcodec2-0.8.1 libcrystalhd3 libcurl3-gnutls libdc1394-25 libdca0 libde265-0 \
    libdouble-conversion1 libdv4 libdvdnav4 libdvdread4 libdw1 libegl-mesa0 libegl1 \
    libenca0 libenchant-2-2 libevdev2 libfaad2 libfftw3-double3 libflac8 libflite1 \
    libfluidsynth1 libfreerdp-client2-2 libfreerdp2-2 libgbm1 libgles2 libgme0 libgomp1 \
    libgpgme11 libgpm2 libgsm1 libgssdp-1.0-3 libgstreamer-gl1.0-0 \
    libgstreamer-plugins-bad1.0-0 libgstreamer-plugins-base1.0-0 libgstreamer-plugins-good1.0-0 \
    libgstreamer1.0-0 libgudev-1.0-0 libgupnp-1.0-4 libgupnp-igd-1.0-4 libharfbuzz-icu0 libhunspell-1.7-0 \
    libhyphen0 libiec61883-0 libigdgmm12 libilmbase23 libinput-bin libinput10 libjack-jackd2-0 libjansson4 \
    libjavascriptcoregtk-4.0-18 libkate1 libldb2 liblilv-0-0 liblmdb0 libltc11 libmanette-0.2-0 \
    libmd4c0 libmjpegutils-2.1-0 libmms0 libmodplug1 libmp3lame0 libmpcdec6 libmpeg2encpp-2.1-0 \
    libmpg123-0 libmplex2-2.1-0 libmtdev1 libmysofa0 libnice10 libnorm1 libnotify4 libnuma1 libofa0 \
    libopenal-data libopenal1 libopenexr23 libopenjp2-7 libopenmpt0 libopenni2-0 libopus0 liborc-0.4-0 \
    libpam-cap libpcre2-16-0 libpgm-5.2-0 libpostproc55 libproxy1v5 libpulse0 libpython3.7 \
    libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libraw1394-11 \
    librcc0 librcd0 librubberband2 libsamplerate0 libsbc1 libsecret-1-0 libsecret-common libserd-0-0 \
    libshine3 libshout3 libslang2 libsndfile1 libsndio7.0 libsodium23 libsord-0-0 libsoundtouch1 libsoup2.4-1 \
    libsoxr0 libspandsp2 libspeex1 libsratom-0-0 libsrtp2-1 libssh-gcrypt-4 libswresample3 \
    libswscale5 libtag1v5 libtag1v5-vanilla libtalloc2 libtevent0 libtheora0 libtwolame0 \
    libusb-1.0-0 libv4l-0 libv4lconvert0 libva-drm2 libva-x11-2 libva2 libvdpau1 libvidstab1.1 libvisual-0.4-0 \
    libvo-aacenc0 libvo-amrwbenc0 libvorbisenc2 libvpx6 libwacom-bin libwacom-common libwacom2 libwavpack1 \
    libwayland-server0 libwbclient0 libwebkit2gtk-4.0-37 libwebpdemux2 libwebpmux3 \
    libwebrtc-audio-processing1 libwildmidi2 libwinpr2-2 libwoff1 libx264-155 libx265-165 \
    libxcb-dpms0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-util1 libxcb-xinerama0 \
    libxcb-xinput0 libxcb-xkb1 libxkbcommon-x11-0 libxslt1.1 libxvidcore4 libzbar0 libzmq5 libzvbi-common \
    libzvbi0 mesa-va-drivers mesa-vdpau-drivers notification-daemon python3-gpg python3-ldb \
    python3-samba python3-talloc python3-tdb qt5-gtk-platformtheme qttranslations5-l10n \
    samba-common samba-common-bin samba-dsdb-modules samba-libs ucf va-driver-all xdg-dbus-proxy zenity \
    zenity-common unzip locales ffmpeg xserver-xorg-video-dummy net-tools xrdp xorgxrdp \
    libccid pcscd libpcsclite1 pcsc-tools opensc libengine-pkcs11-openssl1.1 udev \
    libayatana-appindicator3-1 iproute2 iputils-ping aptitude mc htop

RUN localedef ru_RU.UTF-8 -i ru_RU -f UTF-8 && \
    echo 'LANG="ru_RU.UTF-8"' > /etc/default/locale && \
    update-locale && \
    ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

ENV LANG="ru_RU.UTF-8"
ENV LC_ALL="ru_RU.UTF-8"
ENV TZ="Europe/Moscow"

RUN curl -L http://download.rutoken.ru/Rutoken/PKCS11Lib/2.17.1.0/Linux/x64/librtpkcs11ecp_2.17.1.0-1_amd64.deb -o /tmp/librtpkcs11ecp_2.17.1.0-1_amd64.deb && \
    dpkg -i /tmp/librtpkcs11ecp_2.17.1.0-1_amd64.deb && rm /tmp/librtpkcs11ecp_*.deb

RUN apt autoremove -y && apt-get clean && rm -rf /var/cache/apt /var/lib/apt/lists

#ENTRYPOINT ["/usr/bin/bash"]

RUN curl -L https://github.com/ancwrd1/snx-rs/releases/download/v3.1.1/snx-rs-v3.1.1-linux-x86_64.tar.xz -o /opt/snx-rs-v3.1.1-linux-x86_64.tar.xz && \
    tar axf /opt/snx-rs-v3.1.1-linux-x86_64.tar.xz -C /opt/ && mv /opt/snx-rs-v3.1.1-linux-x86_64 /opt/snx-rs && rm /opt/snx-rs-*

COPY .config /root/.config

COPY astra1.7.zip /tmp/vdi-client/

RUN unzip /tmp/vdi-client/astra1.7.zip -d /tmp/vdi-client && \
    tar -xzpvf /tmp/vdi-client/environment-client*.tgz -C /tmp/vdi-client/ && \
    dpkg -i /tmp/vdi-client/environment-client-agent/*.deb && \
    dpkg -i /tmp/vdi-client/vdi-client_*.deb && \
    rm -rf /tmp/vdi-client

RUN apt autoremove -y && apt-get clean && rm -rf /var/cache/apt /var/lib/apt/lists

RUN useradd -m -s /bin/bash user && echo "user:user" | chpasswd

COPY xrdp-run /usr/bin/
RUN chmod 755 /usr/bin/xrdp-run


# Добавляем новый entrypoint скрипт
COPY entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh

# Копируем иконку приложения
COPY basis-vdi-client.svg /usr/share/icons/


EXPOSE 3389

# Изменяем ENTRYPOINT на новый скрипт
ENTRYPOINT ["/opt/entrypoint.sh"]

