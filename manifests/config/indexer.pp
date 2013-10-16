#splunk indexer configuration class
class splunk::config::indexer (
  $splk_indexer_indexes         = $splunk::splk_indexer_indexes,
  $splk_indexer_tcpports        = $splunk::splk_indexer_tcpports,
  $splk_indexer_udpports        = $splunk::splk_indexer_udpports,
  $splk_indexer_splunktcpports  = $splunk::splk_indexer_splunktcpports,
  $splk_lwf_port                = $splunk::splk_lwf_port) {


  #add the $splk_lwf_port as a splunk_splunktcp_port
  splunk_splunktcp_port{"splunktcp://:${splk_lwf_port}":
      ensure => 'present'}

  # add resources from the various hashes
  create_resources(splunk_index, $splk_indexer_indexes)
  create_resources(splunk_tcp_port, $splk_indexer_tcpports)
  create_resources(splunk_udp_port, $splk_indexer_udpports)
  create_resources(splunk_splunktcp_port, $splk_indexer_splunktcpports)
}