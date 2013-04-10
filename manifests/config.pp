class splunk::config (
  $splunk_indexfs    = "${splunk::indexfs}",
  $admin_password    = "${splunk::admin_password}",
  $splunk_admin_port = "${splunk::splunk_admin_port}") {
  #   test clause for puppet_config type/resource

  splunk_login { "admin": password => $admin_password }
  
  splunk_app { "unix":
    source   => "puppet:///modules/splunk/apps/unix.tar.gz",
    ensure   => "present",
    enabled  => false,
    visible  => false,
  }

  splunk_config { 'default':
    datastore  => $splunk_indexfs,
    hostname   => $fqdn,
    webport    => '8005',
    splunkport => "${splunk_admin_port}",
    minfreemb  => 505,
  }

 
}