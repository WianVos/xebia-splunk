# class splunk::prereq
# installs the prerequisites for a splunk server
class splunk::prereq (
  $splk_indexfs        = $splunk::splk_indexfs,
  $splk_homedir        = $splunk::splk_homedir,
  $splk_user           = $splunk::user,
  $splk_group          = $splunk::splk_group,
  $splk_admin_password = $splunk::splk_admin_password) {
  # input validation


  # flow
  Group['splunk group'] -> User['splunk user'] -> File['splunk homedirectory'] -> File['splunk data filesystem'] -> File ['splunk password file']

  ## dependant flow

  # if the osfamily is redhat .. we need to shutdown iptables.
  if $::osfamily == 'RedHat'  {
    File['splunk data filesystem'] -> Service['iptables'] -> File ['splunk password file']
  }
  # ensurable

  # create users

  group { 'splunk group':
    ensure => present,
    name   => $splk_group,
  }

  user { 'splunk user':
    ensure     => present,
    name       => $splk_group,
    managehome => false,
    gid        => $splk_group,
  }

  # create directory's

  # splunk homedir where the package will be installed

  file { 'splunk homedirectory':
    ensure => directory,
    path   => $splk_homedir,
    owner  => $splk_user,
    group  => $splk_group
  }

  # splunk index filesystem

  file { 'splunk data filesystem':
    ensure => directory,
    path   => $splk_indexfs,
    owner  => $splk_user,
    group  => $splk_group
  }

  # Initialize lvm is needed
  # this requires the puppetlabs lvm module




  # disable iptables on centos and redhat

  service { 'iptables':
    ensure => stopped,
    enable => false }


  # put the splunk username and password in a protected file for use with facter's custom facts.
  file { 'splunk password file':
    path    => '/root/.rc_splunk.txt',
    content => $splk_admin_password,
    mode    => '0666',
    owner   => root
  }
}