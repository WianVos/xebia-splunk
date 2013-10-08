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
  $installtype                   = $splunk::params::installtype,
  $role                          = $splunk::params::role,
  $server                        = $splunk::params::server,
  $stored_configs                = $splunk::params::stored_configs,
  $splk_version                  = $splunk::params::splk_version,
  $splk_homedir                  = $splunk::params::splk_homedir,
  $splk_indexer_indexfs          = $splunk::params::splk_indexer_indexfs,
  $splk_group                    = $splunk::params::splk_group,
  $splk_installsource            = $splunk::params::splk_installsource,
  $splk_client_installsource     = $splunk::params::splk_client_installsource,
  $splk_user                     = $splunk::params::splk_user,
  $splk_admin_password           = $splunk::params::splk_admin_password,
  $splk_adminport                = $splunk::params::splk_adminport,
  $splk_webport                  = $splunk::params::splk_webport,
  $splk_network_interface        = $splunk::params::splk_network_interface,
  $splk_lwf_port                 = $splunk::params::splk_lwf_port,
  $splk_indexer_indexes          = {},
  $splk_indexer_tcpports         = {},
  $splk_indexer_udpports         = {},
  $splk_indexer_splunktcpports   = {},
  ) inherits splunk::params {

  # include various validation checks here
  include splunk::validation

  
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
