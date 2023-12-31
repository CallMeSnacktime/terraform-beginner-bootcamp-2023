# Terraform Beginner Bootcamp 2023 - Week 0

- [Semantic Versioning](#semantic-versioning-mage)
- [Install the Terraform CLI](#install-the-terraform-cli)
    * [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
    * [Considerations for Linux Distributions](#considerations-for-linux-distributions)
    * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
        + [Shebang](#shebang)
        + [Execution Considerations](#execution-considerations)
        + [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle (Before, Init, Command)](#gitpod-lifecycle-before-init-command)
- [Working Env Vars](#working-env-vars)
    * [env command](#env-command)
    * [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
    * [Scoping of Env Vars](#scoping-of-env-vars)
    * [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform](#terraform-basics)
    * [Terraform Registry](#terrraform-registry)
    * [Terraform Console](#terraform-console)
        + [Terraform Init](#terraform-init)
        + [Terraform Plan](#terraform-plan)
        + [Terraform Apply](#terraform-apply)
        + [Terraform Destroy](#terraform-destroy)
        + [Terraform Lock Files](#terraform-lock-files)
        + [Terraform State FIles](#terraform-state-files)
        + [Terraform Directory](#terraform-directory)
- [Terraform Cloud](#terraform-cloud)
    * [Terraform Login](#terraform-login)
    * [Terraform Cloud AWS Credentials](#terraform-cloud-aws-credentials)

## Semantic Versioning :mage:


This project is going to utilize semantic versioning for its tagging
[https://semver.org/](https://semver.org/)

Ther general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.


## Install the Terraform CLI


### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions due to gpg keyring changes. I needed to refer to the latest CLI instructions via terraform Documentation and change the scripting for install

- [Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


### Considerations for Linux Distributions

This project is built on Ubuntu. Please consider checking your Linux Distribution and change accordingly to your needs

- [How To Check OS Version](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:
```
$ cat /etc/os-release

lsb_release -a
hostnamectl
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.3 LTS
Release:        22.04
Codename:       jammy
lsb_release -a
hostnamectl
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.3 LTS
Release:        22.04
Codename:       jammy
```

### Refactoring into Bash Scripts

While fixing the the Terraform CLI gpg depreciation issues I noticed the bash comand steps were a considerable amount more could. So I dicided to create a bash script to install the Terraform CLI

This bash script is located at [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File([.gitpod.yml](.gitpod.yml)) tidy
- This will allow me to more easily debug and execute the Terraform CLI Install
- This will allow better portability for projects that need to install terraform CLI

### Shebang 

A [Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) (Sha-bang) tells the bash script what program will interpret the script. eg. `#!/bin/bash`

CHATGPT recommended this format for bash `#!/usr/bin/env bash`
- Portability for different distributions
- Will seartch user's PATH for bash executable



#### Execution Considerations

When executing bash script we can use the `./` shorthand notation to execute the bash script

eg. `./bin/install_terraform_cli`


If we are using a script in .gitpod.yml we need to point the script to a program to interptet it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change the linux permissions for the file to be executable at the user level:

```sh
chmod u+x ./bin/install_terraform_cli
```

Alternatively:
```sh
chmod 744 ./bin/install_terraform_cli
```
- [Chmod Wiki](https://en.wikipedia.org/wiki/Chmod)

## Gitpod Lifecycle (Before, Init, Command)

We need to becare when using the Init command because it will not rerun if we restart on an existing workspace.

- [Gitpod Workspace Docs](https://www.gitpod.io/docs/configure/workspaces/tasks)

## Working Env Vars

### env command

We can list all Environment Variables (Env Vars) using the `env` command

We can filter specific env vars using grep eg. `env | grap AWS_`

### Setting and Unsetting Env Vars

In the terminal we can set using `export /workspace/terraform-beginner-bootcamp-2023`

In the terminal we can unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set an env without writing export eg.

```
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

### Scoping of Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window. 

If you want env vars to persist acoos all future ternimals that you open, you need to set env vars in your bash profile. eg. `bash_profile`

### Persisting Env Vars in Gitpod

We can persist env vars in gitpod by storing them in Gitpod Secrets Storage

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yam` but this can only contain non-sentivie env vars.

## AWS CLI Installation

AWS CLI is installed for this project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI ENV VARS](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)


To check if its installed use the following command:
```sh
aws --version
```

We can check if our AWS credentials are configured currectly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```

If it is succcessful you should see a json payload return that looks like this:
```json
{
    "UserId": "AWSUSERIDENTITY",
    "Account": "293849383498",
    "Arn": "arn:aws:iam::293849383498:user/user_account"
}
```
> The info listed above is fake

We'll need ti generate AWS CLI credentials from IAM User in order to use the AWS CLI.


## Terraform Basics

### Terrraform Registry

Terraform source their providers and modules form the Terraform registry, which is located at [registry.terrform.io](https://registry.terraform.io)

- **Providers** are interfaces to APIs that will allow you to create resources in terraform.
- **Modules** a way to make large amounts of terraform code modular, portable and sharable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`.

#### Terraform Init

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform provides we need in a project.

#### Terraform Plan

`terraform plan
`
This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to passed to apply, but often you can just ignore outputting

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terrraform. Apply should just  prompt yes or no.

If we want to automatically approve an apply the auto approve flag eg. `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy`
This will destroy resources.

You can also use the auto approve flag to skip the approve prompt eg.

`terraform destroy --auto-approve`

#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers ot modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VCS) eg. Github

#### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure.

This file **should not be committed** to to your VCS

This file can contain sensitive data

If you lose this file, ou lose knowing the state of your infrastructure

`.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers.


## Terraform Cloud


### Getting Started

More details on the following sections can be found in the [Terraform Getting Started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-remote?wvideo=a2i7g8n5zj) page.

### Terraform Login


When attempting to run `terraform login` it will launch a bash prompt to generate a token. 

The workaround is to manually generate a token in Terraform Cloud
```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create file and open the file manually here:
```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```
Provide the following code (replace your token in the file)

```json
{
    "credentials": {
        "app.terraform.io": {
            "token": "Your-Token-Here"
        }
    }
}
```

We have automated a workaround using the following bash script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)

### Terraform Cloud AWS Credentials

When using Terraform Cloud, the AWS environment varibles need to be set in your workspace before you're about to use the `terraform plan` command. At a minumum you need to set:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION


