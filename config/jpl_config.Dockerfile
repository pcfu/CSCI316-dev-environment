FROM leandatascience/jupyterlabconfiguration

RUN apt-get update
RUN apt-get install -y default-jdk scala

RUN cd /home && \
    wget https://downloads.apache.org/spark/spark-3.1.2/spark-3.1.2-bin-hadoop2.7.tgz && \
    tar xf spark-3.1.2-bin-hadoop2.7.tgz && \
    rm spark-3.1.2-bin-hadoop2.7.tgz && \
    mv spark-3.1.2-bin-hadoop2.7 /usr/local/share

COPY config/python-requirements /tmp/python-requirements
RUN pip install --upgrade pip && \
    cat /tmp/python-requirements | xargs -L 1 pip install && \
    rm /tmp/python-requirements

ENV MAIN_PATH=/usr/local/bin/jpl_config
ENV LIBS_PATH=${MAIN_PATH}/libs
ENV CONFIG_PATH=${MAIN_PATH}/config
ENV NOTEBOOK_PATH=${MAIN_PATH}/notebooks

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PYSPARK_PYTHON=/usr/bin/python3
ENV PYSPARK_DRIVER_PYTHON=/usr/local/bin/ipython3
ENV SPARK_HOME=/usr/local/share/spark-3.1.2-bin-hadoop2.7
ENV HADOOP_HOME=/usr/local/share/spark-3.1.2-bin-hadoop2.7
ENV PATH=${PATH}:${JAVA_HOME}:${PYSPARK_PYTHON}:${PYSPARK_DRIVER_PYTHON}:${SPARK_HOME}:${HADOOP_HOME}

EXPOSE 8888

CMD cd ${MAIN_PATH} && sh config/run_jupyter.sh
