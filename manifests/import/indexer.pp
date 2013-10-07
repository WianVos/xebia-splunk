# class splunk::import::indexer
# imports license master info to indexers
class splunk::import::indexer () {
  #   test clause for puppet_config type/resource
  Splunk::Resources::Splunk_license_master <<| |>>
}