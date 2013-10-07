#class splunk::client::prereq
# this class takes care fo installing prerequistes for the splunk universal forwarder
class splunk::client::prereq (
  $lvm            = $splunk::lvm,
  $ensure         = $splunk::ensure,
  $user           = $splunk::user,
  $group          = $splunk::group,
  $admin_password = $splunk::admin_password) {

  # variable setting
  $splunk_homedir = "${splunk::homedir}forwarder"

  # flow
  Group['splunk group'] -> User['splunk user'] -> File['splunk homedirectory'] -> File['splunk password file'
    ]

  # # dependant flow

  # if the osfamily is redhat .. we need to shutdown iptables.
  if $::osfamily == 'RedHat' {
    File['splunk homedirectory'] -> Service['iptables'] -> File['splunk password file']
  }
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


  # disable iptables on centos and redhat

  service { 'iptables':
    ensure => stopped,
    enable => false,
  }

  # put the splunk username and password in a protected file for use with facter's custom facts.
  file { 'splunk password file':
    path    => '/root/.rc_splunk.txt',
    content => $admin_password,
    mode    => '0666',
    owner   => root
  }
}