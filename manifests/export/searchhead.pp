class splunk::export::searchhead (
  $splunk_indexfs    = "${splunk::indexfs}",
  $admin_password    = "${splunk::admin_password}",
  $network_interface = "${splunk::network_interface}",
  $splunk_admin_port = "${splunk::splunk_admin_port}") {
  #   test clause for puppet_config type/resource


 
  
  @@splunk_check_connection{ $network_interface :
     port => $splunk_admin_port
    }
  @@splunk_license_master { $network_interface :
     require => Splunk_check_connection[ $network_interface ]
    }
    
}