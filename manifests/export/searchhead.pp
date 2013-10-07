# this class exports resources about searchhead for others to be imported
class splunk::export::searchhead (
  $network_interface = $splunk::network_interface,
  $splunk_admin_port = $splunk::splunk_admin_port) {

  #   test clause for puppet_config type/resource
  @@splunk::resources::splunk_license_master {$::hostname:
    network_interface => $network_interface,
    splunk_admin_port => $splunk_admin_port
  }



}