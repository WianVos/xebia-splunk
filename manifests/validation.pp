#Class splunk::validation
# this class is here to hold all the validation checks on the class parameters provided to the class at runtime
class splunk::validation{

  case $::osfamily {
    'RedHat' : {}
    default  : {fail("operating system ${::operatingsystem} not supported" )}
  }
  # input validation
  validate_string($splunk::version)
  validate_string($splunk::splk_group)
  validate_string($splunk::splk_user)
  validate_string($splunk::splk_admin_password)

  #validate_portnumber($splunk::splk_adminport,$splunk::splk_webport)
  if versioncmp($::puppetversion , '3.0.0') > 0 {

  validate_absolute_path($splunk::splk_homedir)
  validate_absolute_path($splunk::splk_indexfs)

  validate_ipv4_address($splunk::splk_network_interface)

  }

  # validate the input on the indexer
  validate_hash($splunk::splk_indexer_indexes)
  validate_hash($splunk::splk_indexer_tcpports)
  validate_hash($splunk::splk_indexer_splunktcpports)
  validate_hash($splunk::splk_indexer_udpports)
  validate_hash($splunk::splk_sh_roles)
  validate_hash($splunk::splk_sh_authenticationserver)
  validate_hash($splunk::splk_lm_licenses)
  validate_hash($splunk::splk_apps)


  # verify the installtype
  case $splunk::installtype {
    'rpm'   : {}
    'repo'  : {}
    default : {fail("invalid installtype found ${splunk::installtype}")}
  }
}