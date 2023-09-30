# Terraform Beginner Bootcamp 2023 - Week 1

![image](https://github.com/CallMeSnacktime/terraform-beginner-bootcamp-2023/assets/26889538/8049a3c4-1e55-4cdd-a1ab-89357f0061e1)


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

- TODO: document this flag

### terraform.tfvars

This is the default file to load in terraform variables in bulk

### auto.tfvars

- TODO: document this functionality for terraform cloud

### Order of Terraform Variables

- TODO: document which terrafrom settings takes precedence.

## Dealing With Configuration Drift



## What happens if you lose lose your state file?

If you lose your state fale, you most likely have to tear down all your cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support  import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)
- TODO: Figure out import.tf

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