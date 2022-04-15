FROM clamsproject/clams-python

RUN apt update
RUN apt -y install build-essential wget git-all libssl-dev libleveldb-dev
RUN apt -y install jq

# create folders for VPS source and its dependencies
ENV DEP_PREFIX=/vps/deps
ENV DEP_SRC=/vps/tmp_libsrc
ENV VPS_HOME=/vps/repo
RUN mkdir -p $DEP_PREFIX $DEP_SRC $VPS_HOME

WORKDIR $DEP_SRC
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2.tar.gz && tar -zxvf cmake-3.16.2.tar.gz && cd cmake-3.16.2 && ./configure --prefix=$DEP_PREFIX && make -j 16 && make install
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.gz && tar -zxvf boost_1_78_0.tar.gz && cd boost_1_78_0 && ./bootstrap.sh --prefix=$DEP_PREFIX --with-toolset=gcc --with-libraries=filesystem,thread && ./b2 --with-filesystem --with-thread variant=release threading=multi toolset=gcc install
RUN wget -O leveldb-1.22.tar.gz https://github.com/google/leveldb/archive/1.22.tar.gz && tar -zxvf leveldb-1.22.tar.gz && cd leveldb-1.22 && mkdir cmake_build && cd cmake_build && $DEP_PREFIX"/bin/cmake" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$DEP_PREFIX -DCMAKE_INSTALL_PREFIX=$DEP_PREFIX .. && $DEP_PREFIX"/bin/cmake" --build . && make install
WORKDIR $VPS_HOME
RUN git clone https://gitlab.com/vgg/vps.git && cd vps && mkdir cmake_build && cd cmake_build && $DEP_PREFIX"/bin/cmake" -DCMAKE_PREFIX_PATH=$DEP_PREFIX ../src && make

COPY . /
RUN apt -y install curl
WORKDIR /
RUN chmod +x /start_services.sh
ENTRYPOINT ["./start_services.sh"]