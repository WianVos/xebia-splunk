class splunk::import::client ($admin_password = $splunk::admin_password) {
  #   test clause for puppet_config type/resource
 
 splunk_login { 'admin': password => $admin_password } 
 -> Splunk_forward_server <<| |>>
  
}