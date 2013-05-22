class splunk::export::indexer (
  $splunk_indexfs    = $splunk::indexfs,
  $admin_password    = $splunk::admin_password,
  $network_interface = $splunk::network_interface,
  $splunk_admin_port = $splunk::splunk_admin_port,
  $splunk_lwf_port   = $splunk::splunk_lwf_port ) {
  #   test clause for puppet_config type/resource

  @@splunk_check_connection{$network_interface:
    port => $splunk_admin_port
  }
  @@splunk_search_server { $network_interface:
    port           => $splunk_admin_port,
    remoteuser     => 'admin',
    remotepassword => $admin_password
  }

  @@splunk_forward_server { $network_interface: port => $splunk_lwf_port }

}