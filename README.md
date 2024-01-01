# AWS Lambda Python Zip (alpz)

A series of scripts, supported by Docker, that can prepare an AWS Lambda ZIP package with a Python based Lambda Function. The script will accommodate different Python versions supported by AWS.

Minimum System Requirements:

* A fairly modern Linux distro
* Docker or Podman client installed

Optional requirements:

* GNU Make for installing

# Installation

Run the following:

```shell
# Clone the repo
git clone https://github.com/nicc777/aws-lambda-python-zip-packager.git

# Change into the directory
cd aws-lambda-python-zip-packager

# Install
sudo make install
```

# Usage

After installing, create a Python Lambda function. To include additional requirements, create a `requirements.txt` file in the same directory as the Python script.

Assuming the Python script full path is in `LAMBDA_FUNCTION_SRC_FILE` environment variable, run the following:

```shell
alpz -f $LAMBDA_FUNCTION_SRC_FILE
```

Look for a line  similar to: `DONE - Workdir /tmp/package_132941dce85b4b16805500323475ea88/output contains the resulting ZIP file`

For more command line options run `alpz -h`

The resulting ZIP file can now be uploaded to S3 from where you can deploy your AWS Lambda Function.

A more advanced example that prepares a package with a specific name using the Python 3.10 runtime:

```shell
alpz -f $LAMBDA_FUNCTION_SRC_FILE -p my-package -v 3.10-bookworm
```

# References and More Reading

* [Building Lambda functions with Python](https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html) (AWS Documentation)
* [Working with .zip file archives for Python Lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/python-package.html) (AWS Documentation)
* [Lambda runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) (AWS Documentation)



