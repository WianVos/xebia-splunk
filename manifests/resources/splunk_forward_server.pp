define splunk::export::splunk_forward_server (
  $splunk_lwf_port   = "${splunk::splunk_lwf_port}" ) {
  #   test clause for puppet_config type/resource
 
  @@splunk_check_connection{"splunk_forward_server ${network_interface}":
    port => $splunk_lwf_port
  } ->
  
  @@splunk_forward_server { $network_interface: port => $splunk_lwf_port }
   
}