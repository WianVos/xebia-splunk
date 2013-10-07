#class splunk::config::all
# this class takes care for the linkidge between the searchhead and indexer config classes
class splunk::config::all ($splunk_indexfs = $splunk::indexfs, $admin_password = $splunk::admin_password) {
  # include and flow both the indexer and the searchhead configs
  class { 'splunk::config::searchhead': } -> class { 'splunk::config::indexer': }

}