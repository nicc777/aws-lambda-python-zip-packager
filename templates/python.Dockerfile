FROM python:__VERSION__

RUN apt update && apt upgrade -y && apt install -y zip 

RUN mkdir /data
RUN mkdir /data/src
RUN mkdir /data/output
RUN mkdir /data/scripts
VOLUME ["/data/src", "/data/output", "/data/scripts"]

ENV ENV_PACKAGE_NAME python_lambda_package
ENV ENV_SRC_FILE_NAME not-supplied

CMD /data/scripts/container_package_python_lambda_function.sh -f /data/src/$ENV_SRC_FILE_NAME -p $ENV_PACKAGE_NAME && rm -frR /data/output/venv && rm -frR /data/output/package

