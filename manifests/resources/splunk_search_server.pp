#This defined resource does not have default values for its parameters because it is meant as an exported resource
define splunk::resources::splunk_search_server (
  $admin_password    = $splunk::admin_password,
  $network_interface = $splunk::network_interface,
  $splunk_admin_port = $splunk::splunk_admin_port) {
  #   test clause for puppet_config type/resource

  splunk_check_connection{"splunk_search_server ${::network_interface}":
    port => $splunk_admin_port
  } ->
  splunk_search_server { $::network_interface:
    port           => $splunk_admin_port,
    remoteuser     => 'admin',
    remotepassword => $admin_password,
    require        => Splunk_check_connection["splunk_search_server ${::network_interface}"]
  }


}