terraform {
  # Store the state file in a remote and shared store on GitLab                                                                                                    
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/55456661/terraform/state/PREPROD"
    lock_address   = "https://gitlab.com/api/v4/projects/55456661/terraform/state/PREPROD/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/55456661/terraform/state/PREPROD/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
  }

}
