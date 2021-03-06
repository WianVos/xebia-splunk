#class splunk::params
class splunk::params{

  # module mgt params
  $server                       = true
  $installtype                  = 'rpm'
  $role                         = 'all'
  $stored_configs               = false
  # splunk general params
  $splk_version                 = '6.0-182037'
  $splk_homedir                 = '/opt/splunk'
  $splk_group                   = 'splunk'
  $splk_user                    = 'splunk'
  $splk_adminport               = 8089
  $splk_webport                 = 8000
  $splk_minfreemb               = 500
  $splk_admin_password          = 'test123'
  $splk_network_interface       = $ipaddress_eth1
  $splk_indexfs                 = '/var/splunkdata'
  $splk_installsource           = "puppet:///modules/splunk/rpm/splunk-${splk_version}-linux-2.6-x86_64.rpm"
  $splk_client_installsource    = "puppet:///modules/splunk/rpm/splunkforwarder-${splk_version}-linux-2.6-x86_64.rpm"

  # searchhead params


  # indexer params

  $splk_lwf_port                = '10011'
  $splk_indexer_splunktcpports  = {"splunktcp://:${splk_lwf_port}" => {'ensure' => 'present'}}

  # licensemanager params
  $splk_licensemaster           = false
  # universal forwarder params



}