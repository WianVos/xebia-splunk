class splunk::config::all ($splunk_indexfs = $splunk::indexfs, $admin_password = $splunk::admin_password) {
  # include and flow both the indexer and the searchhead configs
  class { 'splunk::config::searchhead': } -> class { 'splunk::config::indexer': }

}