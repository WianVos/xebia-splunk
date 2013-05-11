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

}