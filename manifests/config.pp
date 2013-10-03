class splunk::config (
  $splunk_indexfs    = $splunk::indexfs,
  $admin_password    = $splunk::admin_password,
  $splunk_admin_port = $splunk::splunk_admin_port,
  $splunk_web_port   = $splunk::splunk_web_port) {
  #   test clause for puppet_config type/resource

  splunk_login { 'admin': password => $admin_password }

  splunk_config { 'default':
    datastore  => $splunk_indexfs,
    hostname   => $fqdn,
    webport    => $splunk_web_port,
    splunkport => $splunk_admin_port,
    minfreemb  => 505,
  }


}