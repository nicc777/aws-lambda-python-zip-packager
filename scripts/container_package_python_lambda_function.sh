#!/usr/bin/env bash

help_message () {
    script_name=${0##*/}
    echo "Usage: ${script_name} -f STRING -p STRING [-h]"
    echo
    echo "  -f STRING   - Path to the Python script to package as AWS Lambda function"
    echo "  -p STRING   - Package name (without any extensions)"
    echo "  -h          - Display help"
    echo
    exit
}

display_help=0
pyhton_script_path=""
package_name="python_lambda_function"

while getopts hf:p: flag
do
    case "${flag}" in
        h) display_help=1;;
        f) pyhton_script_path="/data/src/`basename ${OPTARG}`";;
        p) package_name=${OPTARG};;
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

echo "Starting to package AWS Lamda Function (Python)"

package_dir="/data/output"

echo "  Copy Python lambda function to package directory"
cp $pyhton_script_path $package_dir

requirements_file="`dirname ${pyhton_script_path}`/requirements.txt"
echo "  Checking for the presence of requirements.txt in the same directory as the script: ${requirements_file}"
if test -f $requirements_file; then
    echo "    Adding requirements..."
    cp $requirements_file $package_dir

    echo "    Creating Python virtual environment"
    cd $package_dir
    python3 -m venv venv
    . venv/bin/activate

    echo "    Adding required packages"
    mkdir package
    pip3 install --target ./package -r requirements.txt
    cd package
    zip -r ../${package_name}.zip .

    cd ..
    zip ${package_name}.zip `basename ${pyhton_script_path}`
else
    cd $package_dir
    zip ${package_name}.zip `basename ${pyhton_script_path}`
fi

echo "DONE"
echo
echo "  Pakage File       : ${package_name}.zip"
echo
