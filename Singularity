BootStrap: debootstrap
OSVersion: xenial
MirrorURL: http://us.archive.ubuntu.com/ubuntu/

%setup
    cp gis_dependency.makefile $SINGULARITY_ROOTFS/tmp/

%environment
    GISBASE=/opt/eemt/grass-7.4.0
    GRASS_PROJSHARE=/usr/share/proj
    LD_LIBRARY_PATH=/opt/eemt/lib:/opt/eemt/grass-7.4.0/lib
    PATH=/opt/eemt/bin:/opt/eemt/grass-7.4.0/bin:$PATH
    PYTHONPATH=/opt/eemt/lib/python2.7/site-packages
    export GISBASE GRASS_PROJSHARE LD_LIBRARY_PATH PATH PYTHONPATH

%post
    echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse" >/etc/apt/sources.list

    apt-get update && apt-get install -y --no-install-recommends \
        bison \
        build-essential \
        ccache \
        checkinstall \
        cmake \
        curl \
        ffmpeg2theora \
        flex \
        g++ \
        gcc \
        gettext \
        ghostscript \
        libavcodec-dev \
        libavformat-dev \
        libav-tools \
        libavutil-dev \
        libboost-program-options-dev \
        libboost-thread-dev \
        libcairo2 \
        libcairo2-dev \
        libffmpegthumbnailer-dev \
        libfftw3-3 \
        libfftw3-dev \
        libfreetype6-dev \
        libgcc1 \
        libglu1-mesa-dev \
        libgsl-dev \
        libgtk2.0-dev \
        libgtkmm-3.0-dev \
        libjasper-dev \
        liblas-c-dev \
        libncurses5-dev \
        libnetcdf-dev \
        libperl-dev \
        libpng12-dev \
        libpnglite-dev \
        libpq-dev \
        libproj-dev \
        libreadline6 \
        libreadline6-dev \
        libsqlite3-dev \
        libswscale-dev \
        libtiff5-dev \
        libwxbase3.0-dev   \
        libwxgtk3.0-dev \
        libxmu-dev \
        libxmu-dev \
        libzmq3-dev \
        netcdf-bin \
        openjdk-8-jdk \
        pkg-config \
        proj-bin \
        proj-data \
        python \
        python-dateutil \
        python-dev \
        python-numpy \
        python-opengl \
        python-wxgtk3.0 \
        python-wxtools \
        python-wxversion \
        rsync \
        sqlite3 \
        subversion \
        swig \
        unzip \
        vim \
        wget \
        wx3.0-headers \
        wx-common \
        zlib1g-dev \

# set locale (this fixes an error we had in GRASS environment on startup)
    locale-gen en_US en_US.UTF-8
    dpkg-reconfigure locales 
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment
    echo "LANG=en_US.UTF-8" >> /etc/environment

    cd /tmp && \
       wget -nv http://ccl.cse.nd.edu/software/files/cctools-6.2.4-source.tar.gz && \
       tar xzf cctools-6.2.4-source.tar.gz && \
       cd cctools-6.2.4-source && \
       ./configure --prefix=/opt/eemt && \
       make && \
       make install

 cd /tmp && make -f gis_dependency.makefile

    rm -rf /tmp/build-dir /tmp/cctools*

    echo "Updating library paths"
    cd /etc/ld.so.conf.d
    echo "/opt/eemt/lib" >> eemt.conf
    echo "/opt/eemt/lib64" >> eemt.conf
    echo "/opt/eemt/grass-7.4.0/lib" >> grass.conf
    ldconfig

# once everything is built, we can install GRASS extensions
# Create a dummy mapset so we can install Addons
# Run GRASS74 and Install Addons
    
    export LC_ALL=en_US.UTF-8 && \
        export LANG=en_US.UTF-8 && \
        export PATH=/opt/eemt/bin:/opt/eemt/grass-7.4.0/bin:/opt/eemt/grass-7.4.0/scripts/:$PATH && \
        export GISBASE=/opt/eemt/grass-7.4.0 && \
        rm -rf mytmp_wgs84 && \
        grass74 -text -c epsg:3857 ${PWD}/mytmp_wgs84 -e && \
        echo "g.extension -s extension=r.sun.mp ; g.extension -s extension=r.sun.hourly ; g.extension -s extension=r.sun.daily" | grass74 -text ${PWD}/mytmp_wgs84/PERMANENT

# build info
    echo "Timestamp:" `date --utc` | tee /image-build-info.txt


