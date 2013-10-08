#class splunk::config
# configures the splunk instance
class splunk::config (
  $splunk_indexfs    = $splunk::splk_indexer_indexfs,
  $splk_admin_password    = $splunk::splk_admin_password,
  $splk_adminport = $splunk::splk_adminport,
  $splk_webport   = $splunk::splk_webport) {
  #   test clause for puppet_config type/resource

  splunk_login { 'admin': password => $splk_admin_password }

  splunk_config { 'default':
    datastore  => $splunk_indexfs,
    hostname   => $::fqdn,
    webport    => $splk_webport,
    splunkport => $splk_adminport,
    minfreemb  => 505,
  }


}