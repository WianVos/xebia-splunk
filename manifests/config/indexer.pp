class splunk::config::indexer (
  $splunk_indexfs    = $splunk::indexfs,
  $admin_password    = $splunk::admin_password,
  $network_interface = $splunk::network_interface,
  $splunk_admin_port = $splunk::splunk_admin_port,
  $splunk_lwf_port   = $splunk::splunk_lwf_port) {
  #   test clause for puppet_config type/resource


  splunk_index { 'test_index1': ensure => present }

  splunk_tcp_port { "tcp://${network_interface}:10007":
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_tcp_port { "tcp://${network_interface}:10008":
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_udp_port { "udp://${network_interface}:10009":
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_udp_port { "udp://${network_interface}:10010":
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_splunktcp_port { "splunktcp://:${splunk_lwf_port}":
    ensure             => present,
    enables2sheartbeat => true
  }

}