# Terraform Beginner Bootcamp 2023 - Week 1

![image](https://github.com/CallMeSnacktime/terraform-beginner-bootcamp-2023/assets/26889538/8049a3c4-1e55-4cdd-a1ab-89357f0061e1)


## Fixing Tags

- [How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locally delete a tag

```sh
git tag -d <tag_name>
```
Remotely delete a tag
```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

## Root Module Structure

Our root module structure is as follows:

```
- PROJECT_ROOT
  - main.tf - everything else
  - variables.tf - stores the structure of input variables
  - providers.tf - defines required providers and their configuration
  - outputs.tf - stores our outputs
  - terraform.tfvars - the data of variables we want to load into our terraform project
  - README.md - required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In terraform we can set two kinds of variables.:
- Environment Variables (Ones you set in your bash terminal eg. AWS Credentials)
- Terraform Variables (Ones that you would normally set in your tfvars file)

We can set Terraform Cloud variables to be sensitive so they are not shown in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_uuid="my-user_id"`

### var file

To set lots of variables, it is more convenient to specify their values in a variable definitions file

### terraform.tfvars

This is the default file to load in terraform variables in bulk

### auto.tfvars

Terraform automatically loads files ending with .auto.tfvars or .auto.tfvars.json

### Order of Terraform Variables

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:
- Environment Variables
- The terraform.tfvars file, if present
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided.

## Dealing With Configuration Drift



## What happens if you lose lose your state file?

If you lose your state fale, you most likely have to tear down all your cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support  import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

```
import {
  to = aws_s3_bucket.bucket
  id = "bucket-name"
}
```

### Fix Manual Configuration

When someone deletes/modifies cloud resources manually through *ClickOps*.

If we run `terraform plan` again, it will attempt to put our infrastructure back into the expected state fixing configuration drift.


## Fix using Teraform Refresh (Deprecated)

```sh
terraform apply -refresh-only -auto-approve
```


## Terraform Modules

### Terraform Module Structure

It is recommended to place `modules` in a modules directory when locally developing modules but not mandatory.


### Passing Input Variables

We can pass input variables to our module.

The module has to declare these terraform variables in its own variables.tf


```tf
module "terrahouse_aws"{
  source="./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module Sources

Using  the source we can import the module from various places eg:
- locally
- Github
- Terraform Registry


```tf
module "terrahouse_aws"{
  source="./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)


## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about terraform.

It may likely produce older examples tha could be deprecated. Often affecting provideers.

## Working with Files in Terraform


### Fileexists function

THis is a built in terraform function to check the exsistence of a file.

```tf
condition = fileexists(var.index_html_filepath)
```

[File Exists](https://developer.hashicorp.com/terraform/language/functions/fileexists)

## Filemd5

[Filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root of the project for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references)

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = ${path.root}/public/index.html
}```

### Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need transform data into another format and have it referenced as a variable.

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

This allows us to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

Used the jsonencode to create the json policy inline in the hcl.

```
> jsonencode({"hello"="world"})
{"hello":"world"}

```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

[Terraform Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Provisioners

Provisioners allow you to execute commands on compute instances eg. AWS CLI commands.

They're not recommended for use by Hashicorp becausr Configuration Management tools such as Ansible are a better fit but the functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute a command on the machine running the terraform commands eg. plan apply

```tf
provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
  ```

[Local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec

This will execute commands on a machine  you target. You will need to provide credentials such as ssh to get into the machine

```
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

[Remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

## For Each Expressions

For each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]

```

This is most useful when you are creating multiples of a cloud resource and you want to reduce the amound of repetitive terraform code.


[For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)
