#!/usr/bin/env bash

help_message () {
    script_name=${0##*/}
    echo "Usage: ${script_name} -f STRING [-p STRING] [-v STRING] [-d STRING] [-s STRING] [-h]"
    echo
    echo "  -f STRING   - Path to the Python script to package as AWS Lambda function"
    echo "  -p STRING   - Package name (without any extensions)"
    echo "                (default=python_lambda_function)"
    echo "  -v STRING   - The Desired Python Version (default 3.12-bookworm) - "
    echo "                Check https://hub.docker.com/_/python"
    echo "  -d STRING   - The Docker template path. If not supplied, default is"
    echo "                \$PWD/templates/python.Dockerfile - if you run this script not"
    echo "                from the repo directory, please add this parameter with the"
    echo "                location of the template file."
    echo "  -s STRING   - Path to the container_package_python_lambda_function.sh file"
    echo "                that is in the orignal repo in the /scripts directory."
    echo "                Default is"
    echo "                \$PWD/scripts/container_package_python_lambda_function.sh" 
    echo "  -h          - Display help"
    echo
    exit
}

display_help=0
pyhton_script_path=""
package_name="python_lambda_function"
python_version="3.12-bookworm"
docker_template_file="/usr/share/alpz/python.Dockerfile"
container_script="/usr/lib/alpz/container_package_python_lambda_function.sh"

while getopts hf:p:v:d:s: flag
do
    case "${flag}" in
        h) display_help=1;;
        f) pyhton_script_path=${OPTARG};;
        p) package_name=${OPTARG};;
        v) python_version=${OPTARG};;
        d) docker_template_file=${OPTARG};;
        s) container_script=${OPTARG};;
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

lambda_origin_dir="`dirname ${pyhton_script_path}`"
work_dir="/tmp/package_`cat /proc/sys/kernel/random/uuid | sed 's/[-]//g'`"

mkdir -p $work_dir
mkdir -p $work_dir/src
mkdir -p $work_dir/scripts
mkdir -p $work_dir/output

echo "Preparing Python based Lambda Function Package"
echo
echo "  Original Python File  : ${pyhton_script_path}"
echo "  Source Directory      : ${lambda_origin_dir}"
echo "  Work Directory        : ${work_dir}"
echo "  Docker Template File  : ${docker_template_file}"
echo "  Container Prep Script : ${container_script}" 

echo "  Preparing the docker template for Python version ${python_version}"
echo
cp -vf $docker_template_file $work_dir/Dockerfile
cp -vf $container_script $work_dir/scripts/container_package_python_lambda_function.sh
chmod 700 $work_dir/scripts/container_package_python_lambda_function.sh
sed -i "s/__VERSION__/$python_version/g" $work_dir/Dockerfile
echo "    Docker file ${work_dir}/Dockerfile prepared"
echo

echo "  Coptying Python files"
python_file_name=`basename $pyhton_script_path`
requirements_file="`dirname ${pyhton_script_path}`/requirements.txt"
echo "    Checking for the presence of requirements.txt in the same directory as the script: ${requirements_file}"
cp -vf "$pyhton_script_path" $work_dir/src/$python_file_name
if test -f $requirements_file; then
    cp -vf $requirements_file $work_dir/src/requirements.txt
fi

echo "FILES:"
ls -lahrt ${work_dir} ${work_dir}/src ${work_dir}/scripts ${work_dir}/output

cd $work_dir
docker image rm $package_name
echo "Building Docker Image from directory ${work_dir}"
docker build -t $package_name --build-arg PACKAGE_NAME=$package_name --build-arg SRC_FILE_NAME=$python_file_name .

cd $OLDPWD
docker run --rm \
    -v $work_dir/output:/data/output \
    -v $work_dir/src:/data/src \
    -v $work_dir/scripts:/data/scripts \
    -e ENV_PACKAGE_NAME="${package_name}" \
    -e ENV_SRC_FILE_NAME="${python_file_name}" \
    $package_name

find $work_dir/output/ -type f ! -name '*.zip' -delete

echo "DONE - Workdir ${work_dir}/output contains the resulting ZIP file"
echo
ls -lahrt $work_dir/output

