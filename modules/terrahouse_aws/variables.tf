variable "user_uuid" {
  description = "The UUID of the user"
  type        = string

  validation {
    condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.user_uuid))
    error_message = "The value of var.user_uuid is not in the format of a UUID (e.g., 123e4567-e89b-12d3-a456-426655440000)"
  }
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = (
      length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket_name))
    )
    error_message = "The bucket name must be between 3 and 63 characters, start and end with a lowercase letter or number, and can contain only lowercase letters, numbers, hyphens, and dots."
  }
}

variable "index_html_filepath" {
  description = "Path to the index HTML file"
  type        = string

  validation {
    condition = fileexists(var.index_html_filepath)
    error_message = "The specified index HTML file does not exist or is not a valid path."
  }
}

variable "error_html_filepath" {
  description = "Path to the error HTML file"
  type        = string

  validation {
    condition = fileexists(var.error_html_filepath)
    error_message = "The specified error HTML file does not exist or is not a valid path."
  }
}