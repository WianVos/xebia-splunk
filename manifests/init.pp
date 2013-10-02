# Class: splunk
#
# This module manages splunk in an enterprise way
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class splunk (
  $version              = '6.0-182037',
  $enable               = true,
  $start                = true,
  $homedir              = '/opt/splunk',
  $indexfs              = '/var/splunkdata',
  $lvm                  = false,
  $ensure               = present,
  $group                = 'splunk',
  $user                 = 'splunk',
  $installtype          = 'rpm',
  $admin_password       = 'test123',
  $role                 = 'all',
  $server               = true,
  $splunk_admin_port    = '8089',
  $stored_configs       = true,
  $network_interface    = $ipaddress_eth1,
  $splunk_lwf_port      = '10011',
  $installsource        = "puppet:///modules/splunk/rpm/splunk-6.0-182037-linux-2.6-x86_64.rpm",
  $client_installsource = "puppet:///modules/splunk/rpm/splunkforwarder-6.0-182037-linux-2.6-x86_64.rpm",
  ) {
  
  # input validation
  validate_string($version)
  validate_string($group)
  validate_string($user)
  validate_string($admin_password)

  validate_ipv4_address($network_interface)
  # anchors
  anchor{'splunk::begin':}
  anchor{'splunk::end':}

  # class flow definition



  if $server == true {
    Anchor['splunk::begin'] -> class { 'splunk::prereq': } -> class { 'splunk::install': } -> class { 'splunk::config': } ~> class { 'splunk::service': } ->
    Anchor['splunk::end']

    # add to the flow depending on the role
    case $role {
      'all'        : {
        Class['Splunk::Config'] -> class { 'splunk::config::all': } ~> Class['Splunk::Service']
      }
      'indexer'    : {
        Class['Splunk::Config'] -> class { 'splunk::config::indexer': } ~> Class['Splunk::Service']
      }
      'searchhead' : {
        Class['Splunk::Config'] -> class { 'splunk::config::searchhead': } ~> Class['Splunk::Service'] -> class { 'splunk::post_config_searchhead'
        : }
      }
      'test'       : {
        Class['Splunk::Config'] -> class { 'splunk::config::test': } ~> Class['Splunk::Service']
      }

    }

    if $stored_configs == true {
      case $role {
        'indexer'    : {
          Class['Splunk::Config'] -> class { 'splunk::export::indexer': } -> class { 'splunk::import::indexer': } ~> Class['Splunk::Service'
            ]
        }
        'searchhead' : {
          Class['Splunk::Config'] -> class { 'splunk::export::searchhead': } -> class { 'splunk::import::searchhead': } ~> Class['Splunk::Service'
            ]
        }

      }
    }

  }

  if $server == false {
    Anchor['splunk::begin'] -> class { 'splunk::client::prereq': } -> class { 'splunk::client::install': } ~> class { 'splunk::client::service'
    : } -> Anchor['splunk::end'] 
    if $stored_configs == true {
      Class['Splunk::Client::Install'] -> class {'splunk::import::client': } ~> CLASS['Splunk::Client::Service']
    }
  }
}
