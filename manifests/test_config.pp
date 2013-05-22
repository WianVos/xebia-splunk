class splunk::test_config (
  $splunk_indexfs    = $splunk::indexfs,
  $admin_password    = $splunk::admin_password,
  $splunk_admin_port = $splunk::splunk_admin_port) {
  splunk_login { 'admin': password => $admin_password }

  splunk_config { 'default':
    datastore  => $splunk_indexfs,
    hostname   => $fqdn,
    webport    => '8005',
    splunkport => $splunk_admin_port,
    minfreemb  => 505,
  }

  splunk_tcp_port { 'tcp://192.168.0.1:10007':
    ensure     => absent,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype',
  }

  splunk_tcp_port { 'tcp://192.168.0.2:10007':
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_tcp_port { 'tcp://192.168.0.3:10007':
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_tcp_port { 'tcp://:10007':
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_udp_port { 'udp://192.168.0.1:10009':
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_udp_port { 'udp://192.168.0.1:10010':
    ensure     => present,
    index      => 'test_index1',
    source     => 'testsource',
    sourcetype => 'testtype'
  }

  splunk_splunktcp_port {
  'splunktcp://192.168.0.1:10011':
    ensure             => present,
    enables2sheartbeat => true
  }
  splunk_splunktcp_port { 'splunktcp://192.168.0.2:10011':
    ensure             => present,
    enables2sheartbeat => true
  }
  splunk_authentication_server { 'testldap':
    ensure         => present,
    sslenabled     => 0,
    port           => '636',
    binddn         => 'fuck_off',
    binddnpassword => '$1$W7hjX/MHtfZHZw7Hkxw',
    userbasedn     => ['one', 'two', 'trio'],
    sizelimit      => 500,
  }

  splunk_role{ 'role_test-rolletje4':
    ensure   => present,
    rtsearch => enabled,
  }

  splunk_role { 'role_test-rolletje6':
    ensure   => present,
    rtsearch => enabled,
  }

  splunk_role { 'role_test-rolletjex':
    ensure   => present,
    rtsearch => enabled,
  }
  splunk_role { 'role_test-rolletje2':
    ensure   => present,
    rtsearch => enabled,
    role_map => ['fuck-off2', 'get_lost', 'dick-head']
  }

  splunk_role { 'role_test-rolletje':
    ensure   => present,
    rtsearch => enabled,
    role_map => ['fuck-off2', 'get_lost', 'dick-head']
  }

  splunk_role { 'role_test-rolletje3':
    ensure   => present,
    rtsearch => enabled,
    role_map => ['fuck-off2', 'get_lost', 'dick-head']
  }
   if !defined(Splunk_app['Sideview_utils']) {
    splunk_app { 'sideview_utils':
      ensure   => 'present',
      source   => 'puppet:///modules/splunk/apps/sideview_utils.tar.gz',
      enabled  => true,
      visible  => true,
    }
  }

  splunk_index { 'test_index1':
    ensure   => present
  }
  splunk_index { 'test_index2':
    ensure   => present
  }
  splunk_license { 'Splunk Enterprise':
    ensure => present,
    source => 'puppet:///modules/splunk/licenses/splunk10GBKadaster.license',
  }
}