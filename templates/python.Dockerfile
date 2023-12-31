FROM python:__VERSION__

RUN apt install -y zip 

RUN mkdir -p /data/src
RUN mkdir -p /data/output
RUN mkdir -p /data/scripts
VOLUME ["/data/src", "/data/output", "/data/scripts"]

RUN chmod 700 /data/scripts/*

ENV PACKAGE_NAME package
ENV SRC_FILE_NAME function.py

CMD ["/data/scripts/container_package_python_lambda_function.sh", "-f", "/data/src/${SRC_FILE_NAME}", "-p", "${PACKAGE_NAME}"]

