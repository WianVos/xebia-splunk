# this class configures the basic searchhead needs
class splunk::config::searchhead (
  $splk_sh_roles                  = $splunk::splk_sh_roles,
  $splk_sh_authenticationserver   = $splunk::splk_sh_authenticationserver ) {

  splunk_license { 'Splunk Enterprise':
    ensure => present,
    source => 'puppet:///modules/splunk/licenses/splunk10GBKadaster.license',
  }

  create_resources(splunk_role, $splk_sh_roles)
  create_resources(splunk_authentication_server, $splk_sh_authenticationserver)
}
