#!/usr/bin/env bash

help_message () {
    script_name=${0##*/}
    echo "Usage: ${script_name} -f STRING -p STRING -v STRING [-h]"
    echo
    echo "  -f STRING   - Path to the Python script to package as AWS Lambda function"
    echo "  -p STRING   - Package name (without any extensions)"
    echo "  -v STRING   - The Desired Python Version (default 3.12-bookworm) - Check https://hub.docker.com/_/python"
    echo "  -h          - Display help"
    echo
    exit
}

display_help=0
pyhton_script_path=""
package_name="python_lambda_function"
python_version="3.12-bookworm"

while getopts hf:p:v: flag
do
    case "${flag}" in
        h) display_help=1;;
        f) pyhton_script_path="/data/src/`basename ${OPTARG}`";;
        p) package_name=${OPTARG};;
        v) python_version=${OPTARG};;
    esac
done

if [ "$display_help" -gt "0" ]; then
    help_message
fi

if [ -z "$pyhton_script_path" ]
then
      echo "ERROR: When supplying the -f parameter, a STRING value must be provided. Use the -h parameter for help."
      exit
fi

if ! test -f $pyhton_script_path; then
  echo "ERROR: File does not exist."
  exit
fi

echo "Preparing the docker template"


