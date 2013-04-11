class splunk::config::searchhead (
  $splunk_indexfs    = "${splunk::indexfs}",
  $admin_password    = "${splunk::admin_password}",
  $splunk_admin_port = "${splunk::splunk_admin_port}") {
  #   test clause for puppet_config type/resource


  if !defined(Splunk_app["Sideview_utils"]) {
    splunk_app { "sideview_utils":
      source   => "puppet:///modules/splunk/apps/sideview_utils.tar.gz",
      ensure   => "present",
      enabled  => true,
      visible  => true,
    }
  }

  #
  splunk_authentication_server { "testldap":
    sslenabled     => 0,
    port           => '636',
    binddn         => "fuck_off",
    binddnpassword => '$1$W7hjX/MHtfZHZw7Hkxw',
    userbasedn     => ["one", "two", "trio"],
    sizelimit      => 500,
    ensure         => present
  }

  splunk_role { "role_test-rolletje4":
    rtsearch => enabled,
    ensure   => present
  }

  splunk_role { "role_test-rolletje6":
    rtsearch => enabled,
    ensure   => present
  }

  splunk_role { "role_test-rolletjex":
    rtsearch => enabled,
    ensure   => present
  }

  splunk_role { "role_test-rolletje2":
    rtsearch => enabled,
    ensure   => present,
    role_map => ["fuck-off2", "get_lost", "dick-head"]
  }

  splunk_role { "role_test-rolletje":
    rtsearch => enabled,
    ensure   => present,
    role_map => ["fuck-off2", "get_lost", "dick-head"]
  }

  splunk_role { "role_test-rolletje3":
    rtsearch => enabled,
    ensure   => present,
    role_map => ["fuck-off2", "get_lost", "dick-head"]
  }
  

   splunk_license { "Splunk Enterprise":
    source => "puppet:///modules/splunk/licenses/splunk10GBKadaster.license",
    ensure => present,
  }
  
 
}