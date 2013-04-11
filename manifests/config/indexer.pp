class splunk::config::indexer (
  $splunk_indexfs    = "${splunk::indexfs}",
  $admin_password    = "${splunk::admin_password}",
  $network_interface = "${splunk::network_interface}",
  $splunk_admin_port = "${splunk::splunk_admin_port}") {
  #   test clause for puppet_config type/resource


  splunk_index { "test_index1": ensure => present }

#  splunk_tcp_port { "tcp://${network_interface}:10007":
#    ensure     => present,
#    index      => 'test_index1',
#    source     => 'testsource',
#    sourcetype => 'testtype'
#  }
#
#  splunk_tcp_port { "tcp://${network_interface}:10008":
#    ensure     => present,
#    index      => 'test_index1',
#    source     => 'testsource',
#    sourcetype => 'testtype'
#  }
#
#  splunk_udp_port { "udp://${network_interface}:10009":
#    ensure     => present,
#    index      => 'test_index1',
#    source     => 'testsource',
#    sourcetype => 'testtype'
#  }
#
#  splunk_udp_port { "udp://${network_interface}:10010":
#    ensure     => present,
#    index      => 'test_index1',
#    source     => 'testsource',
#    sourcetype => 'testtype'
#  }
#
#  splunk_splunktcp_port { "splunktcp://:10011":
#    ensure             => present,
#    enables2sheartbeat => true
#  }
  
  @@splunk_check_connection{"${network_interface}":
    port => $splunk_admin_port
  }
  @@splunk_search_server { "${network_interface}":
    port           => $splunk_admin_port,
    remoteuser     => "admin",
    remotepassword => $admin_password
  }
  
  
  #  splunk_check_connection{"192.168.50.5":
  #    port => 8089
  #  }
  #  splunk_license_master {"192.168.50.5":
  #    require => Splunk_check_connection["192.168.50.5"]
  #  }
}