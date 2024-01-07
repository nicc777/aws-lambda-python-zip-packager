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

A more advanced example that prepares a package with a specific name using the Python 3.10 runtime and saving the path to the resulting ZIP file in `/tmp/output.json`:

```shell
# Run the command
alpz -f $LAMBDA_FUNCTION_SRC_FILE -p my-package -v 3.10-bookworm -o /tmp/output.json

# Get the ZIP file from the generated output file:
cat /tmp/output.json

# Check:
ls -lahrt /tmp/package_701b6afc39af4cb690cfeae01b855f90/output/my-package.zip
```

The JSON file generated will look something like this:

```json
{
    "ZipFilePath": "/tmp/package_701b6afc39af4cb690cfeae01b855f90/output/my-package.zip", 
    "WorkDir": "/tmp/package_701b6afc39af4cb690cfeae01b855f90"
}
```

# What images are available?

To check what options you can pass to the `-v` option, run the following command:

```shell
curl -s https://registry.hub.docker.com/v2/repositories/library/python/tags\?page_size\=1000 | jq -r ".results[].name" | sort --version-sort | grep "\-bookworm" | grep -v slim
```

Expect output similar to this:

```text
3-bookworm
3.8-bookworm
3.8.18-bookworm
3.9-bookworm
3.9.18-bookworm
3.10-bookworm
3.10.13-bookworm
3.11-bookworm
3.11.7-bookworm
3.12-bookworm
3.12.1-bookworm
3.13-rc-bookworm
3.13.0a2-bookworm
```

From this list, pick a suitable version that is also [supported by AWS](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)

# References and More Reading

* [Building Lambda functions with Python](https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html) (AWS Documentation)
* [Working with .zip file archives for Python Lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/python-package.html) (AWS Documentation)
* [Lambda runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) (AWS Documentation)



