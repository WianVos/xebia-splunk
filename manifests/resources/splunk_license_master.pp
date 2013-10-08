#This defined resource does not have default values for its parameters because it is meant as an exported resource
define splunk::resources::splunk_license_master (
  $splk_network_interface,
  $splk_adminport ) {
  #   test clause for puppet_config type/resource


  splunk_check_connection { "splunk_license_master ${network_interface}": port => $splk_adminport } ->   splunk_license_master { $splk_network_interface:}


}