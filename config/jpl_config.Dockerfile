FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update -qq && apt-get upgrade -yq && apt-get install -yq --no-install-recommends \
    build-essential  \
    checkinstall \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    zlib1g-dev \
    openssl \
    libffi-dev \
    openjdk-8-jdk \
    scala \
    python3-dev \
    python3-setuptools \
    wget \
    pandoc \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic

RUN cd /home && \
    wget https://downloads.apache.org/spark/spark-3.1.2/spark-3.1.2-bin-hadoop2.7.tgz && \
    tar xf spark-3.1.2-bin-hadoop2.7.tgz && \
    rm spark-3.1.2-bin-hadoop2.7.tgz && \
    mv spark-3.1.2-bin-hadoop2.7 /usr/local/share

RUN cd /home && \
    wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz && \
    tar xf hadoop-2.7.7.tar.gz && \
    rm hadoop-2.7.7.tar.gz && \
    mv hadoop-2.7.7 /usr/local/share

RUN ln -s /usr/bin/python3.8 /usr/bin/python
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && rm get-pip.py

COPY config/python-requirements /tmp/python-requirements
RUN pip install --upgrade pip && \
    cat /tmp/python-requirements | xargs -L 1 pip install && \
    rm /tmp/python-requirements
RUN python -m bash_kernel.install

ENV MAIN_PATH=/usr/local/bin/jpl_config
ENV LIBS_PATH=${MAIN_PATH}/libs
ENV CONFIG_PATH=${MAIN_PATH}/config
ENV NOTEBOOK_PATH=${MAIN_PATH}/notebooks

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PYSPARK_PYTHON=/usr/bin/python3
ENV PYSPARK_DRIVER_PYTHON=/usr/local/bin/ipython3
ENV SPARK_HOME=/usr/local/share/spark-3.1.2-bin-hadoop2.7
ENV HADOOP_HOME=/usr/local/share/hadoop-2.7.7
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native
ENV PATH=${PATH}:${JAVA_HOME}:${PYSPARK_PYTHON}:${PYSPARK_DRIVER_PYTHON}:${SPARK_HOME}:${HADOOP_HOME}

EXPOSE 8888

WORKDIR ${MAIN_PATH}

CMD cd ${MAIN_PATH} && sh config/run_jupyter.sh
