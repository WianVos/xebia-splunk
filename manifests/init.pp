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
  $splk_licensemaster            = $splunk::params::splk_licensemaster,
  $splk_version                  = $splunk::params::splk_version,
  $splk_homedir                  = $splunk::params::splk_homedir,
  $splk_indexfs                  = $splunk::params::splk_indexfs,
  $splk_group                    = $splunk::params::splk_group,
  $splk_installsource            = $splunk::params::splk_installsource,
  $splk_client_installsource     = $splunk::params::splk_client_installsource,
  $splk_user                     = $splunk::params::splk_user,
  $splk_admin_password           = $splunk::params::splk_admin_password,
  $splk_adminport                = $splunk::params::splk_adminport,
  $splk_webport                  = $splunk::params::splk_webport,
  $splk_minfreemb                = $splunk::params::splk_minfreemb,
  $splk_network_interface        = $splunk::params::splk_network_interface,
  $splk_lwf_port                 = $splunk::params::splk_lwf_port,
  $splk_indexer_indexes          = {},
  $splk_indexer_tcpports         = {},
  $splk_indexer_udpports         = {},
  $splk_indexer_splunktcpports   = {},
  $splk_sh_roles                 = {},
  $splk_sh_authenticationserver  = {},
  $splk_lm_licenses              = {},
  $splk_apps                     = {},
  ) inherits splunk::params {

  include splunk::validation

  # anchors
  anchor{'splunk::begin':}
  anchor{'splunk::end':}

  # class flow definition



  if str2bool($server) {
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
      'searchhead' : {Class['Splunk::Config'] -> class { 'splunk::config::searchhead': } ~> Class['Splunk::Service']}
      default      : { fail("role parameter contains a value ${role} not supported by this module")}
    }

    if str2bool($stored_configs)  {
      case $role {
        'indexer'    : {Class['Splunk::Config'] -> class { 'splunk::export::indexer': } -> class { 'splunk::import::indexer': } ~> Class['Splunk::Service']}
        'searchhead' : {Class['Splunk::Config'] -> class { 'splunk::import::searchhead': } ~> Class['Splunk::Service']}
        default      : { fail("role parameter contains a value ${role} not supported by this module")}
        }
      }
    if str2bool($splk_licensemaster) {
      Class['Splunk::Config'] -> class{'splunk::config::licensemaster':}  ~> Class['Splunk::Service']
      if str2bool($stored_configs)  {
        Class['Splunk::Config::Licensemaster'] -> class { 'splunk::export::licensemaster': } ~> Class['Splunk::Service']
      }
    }
  }


  if str2bool($server) == false {
    Anchor['splunk::begin'] -> class { 'splunk::client::prereq': } -> class { 'splunk::client::install': } -> class{ 'splunk::client::config':} ~> class { 'splunk::service': } -> Anchor['splunk::end']
    if str2bool($stored_configs) {Class['Splunk::Client::Install'] -> class {'splunk::import::client': } ~> Class['Splunk::Service']}
  }
}
