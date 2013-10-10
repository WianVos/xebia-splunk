# this class exports resources for others to be imported
class splunk::export::indexer (
  $splunk_indexfs    = $splunk::splk_indexer_indexfs,
  $splk_admin_password    = $splunk::splk_admin_password,
  $splk_network_interface = $splunk::splk_network_interface,
  $splk_adminport = $splunk::splk_adminport,
  $splk_lwf_port   = $splunk::splk_lwf_port ) {
  #   test clause for puppet_config type/resource

  @@splunk_check_connection{$splk_network_interface:
    port => $splk_adminport
  }

  @@splunk_search_server { $splk_network_interface:
    port           => $splk_adminport,
    remoteuser     => 'admin',
    remotepassword => $splk_admin_password
  }

  @@splunk_forward_server { $splk_network_interface: port => $splk_lwf_port }

}