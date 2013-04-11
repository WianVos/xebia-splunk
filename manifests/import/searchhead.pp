class splunk::import::indexer (
  $splunk_indexfs    = "${splunk::indexfs}",
  $admin_password    = "${splunk::admin_password}",
  $splunk_admin_port = "${splunk::splunk_admin_port}") {
  #   test clause for puppet_config type/resource
  
  Splunk_search_server <<| |>>
  Splunk_check_connection <<| |>>
  
}