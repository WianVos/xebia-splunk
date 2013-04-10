class splunk::config::indexer ($splunk_indexfs = "${splunk::indexfs}", $admin_password = "${splunk::admin_password}") {
  #   test clause for puppet_config type/resource


 
  splunk_index { "test_index1":
    ensure   => present
  }

  splunk_tcp_port { "tcp://192.168.0.1:10007":
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_tcp_port { "tcp://192.168.0.1:10008":
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_udp_port { "udp://192.168.0.1:10009":
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_udp_port { "udp://192.168.0.1:10010":
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_splunktcp_port { "splunktcp://:10011":
    ensure             => present,
    enables2sheartbeat => true
  }
  splunk_check_connection{"192.168.50.5":
    port => 8089
  }
  splunk_license_master {"192.168.50.5":
    require => Splunk_check_connection["192.168.50.5"] 
  }
}