# class splunk::prereq
# installs the prerequisites for a splunk server
class splunk::prereq (
  $lvm            = $splunk::lvm,
  $splunk_indexfs = $splunk::indexfs,
  $splunk_homedir = $splunk::homedir,
  $ensure         = $splunk::ensure,
  $user           = $splunk::user,
  $group          = $splunk::group,
  $admin_password = $splunk::admin_password) {
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
    name   => $group,
  }

  user { 'splunk user':
    ensure     => present,
    name       => $group,
    managehome => false,
    gid        => $group,
  }

  # create directory's

  # splunk homedir where the package will be installed

  file { 'splunk homedirectory':
    ensure => directory,
    path   => $splunk_homedir,
    owner  => $user,
    group  => $group
  }

  # splunk index filesystem

  file { 'splunk data filesystem':
    ensure => directory,
    path   => $splunk_indexfs,
    owner  => $user,
    group  => $group
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
    content => $admin_password,
    mode    => '0666',
    owner   => root
  }
}