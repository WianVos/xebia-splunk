# class splunk::import::client
# this class imports all exported indexer configuration in order to configure itself
class splunk::import::client ($splk_admin_password = $splunk::splk_admin_password) {
  #   test clause for puppet_config type/resource

  splunk_login { 'admin': password => $splk_admin_password }
    -> Splunk_forward_server <<| |>>
}