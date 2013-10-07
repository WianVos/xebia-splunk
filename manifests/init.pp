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
  $splunk_admin_port    = 8089,
  $splunk_web_port      = 8000,
  $stored_configs       = true,
  $network_interface    = $ipaddress_eth1,
  $splunk_lwf_port      = '10011'
  ) {

  # input validation
  validate_string($version)
  validate_string($group)
  validate_string($user)
  validate_string($admin_password)

  validate_portnumber($splunk_admin_port,$splunk_web_port)


  validate_absolute_path($homedir)
  validate_absolute_path($indexfs)


  validate_ipv4_address($network_interface)

  case $installtype {
    'rpm'   : {}
    'repo'  : {}
    default : {fail("invalid installtype found ${installtype}")}
  }

  # composed variables
  $installsource        = "puppet:///modules/splunk/rpm/splunk-${version}-linux-2.6-x86_64.rpm"
  $client_installsource = "puppet:///modules/splunk/rpm/splunkforwarder-${version}-linux-2.6-x86_64.rpm"

  # anchors
  anchor{'splunk::begin':}
  anchor{'splunk::end':}

  # class flow definition



  if $server == true {
    Anchor['splunk::begin']
    -> class { 'splunk::prereq': }
    -> class { 'splunk::install': }
    -> class { 'splunk::config': }
    ~> class { 'splunk::service': }
    -> Anchor['splunk::end']

    # add to the flow depending on the role
    case $role {
      'all'        : {Class['Splunk::Config'] -> class { 'splunk::config::all': } ~> Class['Splunk::Service']}
      'indexer'    : {Class['Splunk::Config'] -> class { 'splunk::config::indexer': } ~> Class['Splunk::Service']}
      'searchhead' : {Class['Splunk::Config'] -> class { 'splunk::config::searchhead': } ~> Class['Splunk::Service'] -> class { 'splunk::post_config_searchhead':}}
      default      : { fail('role parameter contains a value not supported by this module')}
    }

    if $stored_configs == true {
      case $role {
        'indexer'    : {Class['Splunk::Config'] -> class { 'splunk::export::indexer': } -> class { 'splunk::import::indexer': } ~> Class['Splunk::Service']}
        'searchhead' : {Class['Splunk::Config'] -> class { 'splunk::export::searchhead': } -> class { 'splunk::import::searchhead': } ~> Class['Splunk::Service']}
        default      : { fail('role parameter contains a value not supported by this module')}
        }
      }
    }


  if $server == false {
    Anchor['splunk::begin'] -> class { 'splunk::client::prereq': } -> class { 'splunk::client::install': } ~> class { 'splunk::client::service': } -> Anchor['splunk::end']
    if $stored_configs == true {Class['Splunk::Client::Install'] -> class {'splunk::import::client': } ~> Class['Splunk::Client::Service']}
  }
}
