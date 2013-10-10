#class splunk::config
# configures the splunk instance
class splunk::config (
  $splk_indexfs           = $splunk::splk_indexfs,
  $splk_admin_password    = $splunk::splk_admin_password,
  $splk_adminport         = $splunk::splk_adminport,
  $splk_webport           = $splunk::splk_webport,
  $splk_minfreemb         = $splunk::splk_minfreemb) {
  #   test clause for puppet_config type/resource

  splunk_login { 'admin': password => $splk_admin_password }

  splunk_config { 'default':
    datastore  => $splk_indexfs,
    hostname   => $::fqdn,
    webport    => $splk_webport,
    splunkport => $splk_adminport,
    minfreemb  => $splk_minfreemb,
  }


}