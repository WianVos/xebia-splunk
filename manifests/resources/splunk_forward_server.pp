# this defined type is used to export splunk_forward_server stuff
define splunk::resources::splunk_forward_server (
  $splk_lwf_port   = $splunk::splk_lwf_port ) {
  #   test clause for puppet_config type/resource

  @@splunk_check_connection{"splunk_forward_server ${::splk_network_interface}":
    port => $splk_lwf_port
  }

  @@splunk_forward_server { $::splk_network_interface: port => $splk_lwf_port }
}