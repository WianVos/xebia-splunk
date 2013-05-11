class splunk::prereq (
  $lvm            = "${splunk::lvm}",
  $splunk_indexfs = "${splunk::indexfs}",
  $splunk_homedir = "${splunk::homedir}",
  $ensure         = "${splunk::ensure}",
  $user           = "${splunk::user}",
  $group          = "${splunk::group}",
  $admin_password = "${splunk::admin_password}") {
  # input validation


  # flow
  Group["splunk group"] -> User["splunk user"] -> File["splunk homedirectory"] -> File["splunk data filesystem"] -> File ["splunk password file"]

  ## dependant flow 
  
  # if the osfamily is redhat .. we need to shutdown iptables. 
  if $osfamily == 'RedHat'  {
    File["splunk data filesystem"] -> Service["iptables"] -> File ["splunk password file"]
  }
  # ensurable

  $manage_directory = $ensure ? {
    absent  => 'absent',
    default => 'directory'
  }

  $manage_user = $ensure ? {
    absent  => 'absent',
    default => 'present'
  }

  # create users

  group { "splunk group":
    name   => "${group}",
    ensure => "${manage_user}"
  }

  user { "splunk user":
    name       => "${group}",
    ensure     => "${manage_user}",
    managehome => false,
    gid        => "${group}",
  }

  # create directory's

  # splunk homedir where the package will be installed

  file { "splunk homedirectory":
    path   => "${splunk_homedir}",
    ensure => "${manage_directory}",
    owner  => "${user}",
    group  => "${group}"
  }

  # splunk index filesystem

  file { "splunk data filesystem":
    path   => "${splunk_indexfs}",
    ensure => "${manage_directory}",
    owner  => "${user}",
    group  => "${group}"
  }

  # Initialize lvm is needed
  # this requires the puppetlabs lvm module
  
  


  # disable iptables on centos and redhat
  
 service { 'iptables': enable => false, ensure => stopped }
  

  # put the splunk username and password in a protected file for use with facter's custom facts. 
  file { "splunk password file":
    path => '/root/.rc_splunk.txt',
    content => $admin_password,
    mode => 0666,
    owner => root
  }
}