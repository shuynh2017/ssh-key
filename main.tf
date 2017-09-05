##############################################################################
# Require terraform 0.9.3 or greater er
##############################################################################
terraform {
  required_version = ">= 0.9.3"
}
##############################################################################
# IBM Cloud Provider
##############################################################################
# See the README for details on ways to supply these values
provider "ibm" {
  bluemix_api_key = "${var.bxapikey}"
  softlayer_username = "${var.slusername}"
  softlayer_api_key = "${var.slapikey}"
}

##############################################################################
# IBM SSH Key: For connecting to VMs
##############################################################################
resource "ibm_compute_ssh_key" "ssh_key" {
  label = "${var.key_label}"
  notes = "${var.key_note}"
  # Public key, so this is completely safe
  public_key = "${var.public_key}"
}

# Create a virtual server with the SSH key.
resource "ibm_compute_vm_instance" "my_server_2" {
  hostname          = "shuynh1.example.com"
  domain            = "example.com"
  ssh_keys          = [123456, "${ibm_compute_ssh_key.keyLabel1.id}"]
  os_reference_code = "CENTOS_6_64"
  datacenter        = "tor01"
  network_speed     = 10
  cores             = 1
  memory            = 1024
}

##############################################################################
# Variables
##############################################################################
variable bxapikey {
  description = "Your Bluemix API Key."
}
variable slusername {
  description = "Your Softlayer username."
}
variable slapikey {
  description = "Your Softlayer API Key."
}
variable datacenter {
  description = "The datacenter to create resources in."
}
variable public_key {
  description = "Your public SSH key material."
}
variable key_label {
  description = "A label for the SSH key that gets created."
}
variable key_note {
  description = "A note for the SSH key that gets created."
}

##############################################################################
# Outputs
##############################################################################
output "ssh_key_id" {
  value = "${ibm_compute_ssh_key.ssh_key.id}"
}
