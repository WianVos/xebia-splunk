class splunk::client::config ($admin_password = "${splunk::admin_password}", $splunk_admin_port = "${splunk::splunk_admin_port}") {
  splunk_login { "admin": password => $admin_password }

  #splunk_forward_server { "192.168.111.2": port => 10011 }

  splunk_app { "Splunk_TA_nix":
    source  => "puppet:///modules/splunk/apps/Splunk_TA_nix.tar.gz",
    ensure  => "present",
    enabled => true,
    visible => true,
    require => Splunk_login["admin"]
  }
  splunk_monitor{"script://./bin/vmstat.sh":
    app => "Splunk_TA_nix",
    interval => 120,
    disabled => 0,
    index => 'os',
    source => 'vmstat',
    sourcetype => 'vmstat',
    ensure => present
  }
 splunk_monitor{"fschange:/etc":
    app => "Splunk_TA_nix",
    disabled => 0
  }
 splunk_monitor{"monitor:///var/log":
  blacklist=>'(lastlog)',
  index=>"os",
  disabled => 0
  }
}