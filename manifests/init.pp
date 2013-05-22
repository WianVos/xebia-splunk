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
  $version              = '5.0.2-149561',
  $enable               = true,
  $start                = true,
  $homedir              = '/opt/splunk',
  $indexfs              = '/var/splunkdata',
  $lvm                  = false,
  $ensure               = present,
  $group                = 'splunk',
  $user                 = 'splunk',
  $installtype          = 'rpm',
  $installsource        = 'puppet:///modules/splunk/rpm/splunk-5.0.2-149561-linux-2.6-x86_64.rpm',
  $client_installsource = 'puppet:///modules/splunk/rpm/splunkforwarder-5.0.2-149561-linux-2.6-x86_64.rpm',
  $admin_password       = 'test123',
  $role                 = 'all',
  $server               = true,
  $splunk_admin_port    = '8089',
  $lvmdisks             = 'none',
  $splunk_lvm_vg        = 'splunkvg',
  $splunk_lvm_lv        = 'splunklv',
  $stored_configs       = true,
  $network_interface    = $ipaddress_eth1,
  $splunk_lwf_port      = '10011' ) {
  # input validation


  # class flow definition

  if $server == true {
    class { 'splunk::prereq': } -> class { 'splunk::install': } -> class { 'splunk::config': } ~> class { 'splunk::service': } ->
    Class['splunk']

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
    class { 'splunk::client::prereq': } -> class { 'splunk::client::install': } -> class { 'splunk::client::config': } ~> class { 'splunk::client::service'
    : } -> Class['splunk']
    if $stored_configs == true {
      Class['Splunk::Client::Config'] -> class {'splunk::import::client': } ~> CLASS['Splunk::Client::Service']
    }
  }
}
