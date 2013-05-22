class splunk::config::searchhead (
  $splunk_indexfs    = $splunk::indexfs,
  $admin_password    = $splunk::admin_password,
  $splunk_admin_port = $splunk::splunk_admin_port) {
  #   test clause for puppet_config type/resource


  if !defined(Splunk_app['Sideview_utils']) {
    splunk_app { 'sideview_utils':
      ensure   => 'present',
      source   => 'puppet:///modules/splunk/apps/sideview_utils.tar.gz',
      enabled  => true,
      visible  => true,
    }
  }

  #
  splunk_authentication_server { 'testldap':
    ensure         => present,
    sslenabled     => 0,
    port           => '636',
    binddn         => 'fuck_off',
    binddnpassword => '$1$W7hjX/MHtfZHZw7Hkxw',
    userbasedn     => ['one', 'two', 'trio'],
    sizelimit      => 500,
  }

  splunk_role { 'role_test-rolletje4':
    ensure   => present,
    rtsearch => enabled,
  }

  splunk_role { 'role_test-rolletje6':
    ensure   => present,
    rtsearch => enabled,
    }

  splunk_role { 'role_test-rolletjex':
    ensure => present,
    rtsearch => enabled,
  }

  splunk_role { 'role_test-rolletje2':
    ensure => present,
    rtsearch => enabled,
    role_map => ['fuck-off2', 'get_lost', 'dick-head']
  }

  splunk_role { 'role_test-rolletje':
    ensure   => present,
    rtsearch => enabled,
    role_map => ['fuck-off2', 'get_lost', 'dick-head']
  }

  splunk_role { 'role_test-rolletje3':
    ensure => present,
    rtsearch => enabled,
    role_map => ['fuck-off2', 'get_lost', 'dick-head']
  }


   splunk_license { 'Splunk Enterprise':
    ensure => present,
    source => 'puppet:///modules/splunk/licenses/splunk10GBKadaster.license',
  }


}