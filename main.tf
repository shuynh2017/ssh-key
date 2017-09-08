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
resource "ibm_compute_vm_instance" "master" {
  hostname          = "${var.master_hostname}"
  domain            = "domain.com"
  #ssh_keys          = [123456, "${ibm_compute_ssh_key.keyLabel1.id}"]
  datacenter        = "${var.datacenter}"
  #os_reference_code = "CENTOS_6_64"
  image_id          = 1735853
  network_speed     = 100
  cores             = "${var.master_cores}"
  memory            = 8192
  post_install_script_uri = "${var.post_install_script_uri}"
  user_metadata     = "{\"X\":_QUOTE_Y_QUOTE_}"
}

# Create a virtual server with the SSH key.
resource "ibm_compute_vm_instance" "computes" {
  hostname          = "${var.compute_prefix}${count.index}"
  domain            = "domain.com"
  #ssh_keys          = [123456, "${ibm_compute_ssh_key.keyLabel1.id}"]
  datacenter        = "${var.datacenter}"
  #os_reference_code = "CENTOS_6_64"
  image_id          = 1735853
  network_speed     = 100
  cores             = "${var.compute_cores}"
  memory            = 8192
  count 	    = "${var.num_compute}"
#  user_metadata     = "{\"masterIP\":${ibm_compute_vm_instance.master.ipv4_address}, \"masterHostName\": ${var.master_hostname}}"
  user_metadata     = "{\"masterIP\":_QUOTE_${ibm_compute_vm_instance.master.ipv4_address}_QUOTE_, \"masterHostName\": _QUOTE_${var.master_hostname}_QUOTE_}"
  post_install_script_uri = "${var.post_install_script_uri}"
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

variable num_compute {
  description = "Number of compute nodes"
}

variable master_hostname {
  description = "Name of master host"
}

variable master_cores {
  description = "Number of cores for master host"
}

variable compute_cores {
  description = "Number of cores for each compute host"
}

variable compute_prefix {
  description = "Prefix for compute host which will be appended with number of compute, e.g., compute0, compute1 "
}

variable post_install_script_uri {
  description = "e.g., https://ip/SpectrumSymphony.sh, https://ip/SpectrumConductor.sh"
}


##############################################################################
# Outputs
##############################################################################
output "ssh_key_id" {
  value = "${ibm_compute_ssh_key.ssh_key.id}"
}
