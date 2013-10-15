# this class exports resources about searchhead for others to be imported
class splunk::export::licensemaster (
  $splk_network_interface = $splunk::splk_network_interface,
  $splk_adminport = $splunk::splk_adminport,) {

  #   test clause for puppet_config type/resource
  @@splunk::resources::splunk_license_master {$::hostname:
    splk_adminport         => $splk_adminport,
    splk_network_interface => $splk_network_interface
  }



}