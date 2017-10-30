FROM centos

RUN yum -y install epel-release && \
    yum -y install clang-analyzer cloc cmake cmake3 cppcheck doxygen findutils gcc gcc-c++ git graphviz lcov make python2-pip valgrind vim-common && \
    yum -y autoremove && \
    yum clean all

RUN pip install conan==0.28.0 coverage==4.4.1 flake8==3.4.1 gcovr==3.3 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

COPY files/registry.txt $CONAN_USER_HOME/.conan/

RUN git clone https://github.com/ess-dmsc/utils.git && \
    cd utils && \
    git checkout 98b81cf00f80ceb8383eb4dc6abb27669959e11b && \
    make install

RUN adduser jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

USER jenkins

WORKDIR /home/jenkins
