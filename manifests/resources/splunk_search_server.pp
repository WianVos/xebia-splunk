#This defined resource does not have default values for its parameters because it is meant as an exported resource
define splunk::resources::splunk_search_server (
  $splk_admin_password    = $splunk::splk_admin_password,
  $splk_network_interface = $splunk::splk_network_interface,
  $splk_adminport         = $splunk::splk_adminport) {
  #   test clause for puppet_config type/resource

  splunk_check_connection{"splunk_search_server ${::splk_network_interface}":
    port => $splk_adminport
  } ->
  splunk_search_server { $::splk_network_interface:
    port           => $splk_adminport,
    remoteuser     => 'admin',
    remotepassword => $splk_admin_password,
    require        => Splunk_check_connection["splunk_search_server ${::splk_network_interface}"]
  }


}