# splunk::install
class splunk::install (
  $version        = $splunk::version,
  $installtype    = $splunk::installtype,
  $installsource  = $splunk::installsource,
  $ensure         = $splunk::ensure,
  $splunk_homedir = $splunk::homedir,
  $admin_password = $splunk::admin_password) {
  # input validation


  # variable setting

  $manage_package = $ensure ? {
    absent  => 'absent',
    default => 'present'
  }

  $manage_link = $ensure ?{
    absent => 'absent',
    default => 'link'
  }

  # flow
  Package['splunk'] -> Exec['splunk initial password change'] -> Exec['splunk enable boot-start'] -> File['splunk sbin link'] -> File['splunk etc link'] -> File['splunk var link']

  # package installation
  # rpm installation should be removed after vagrant development fase (it's just that ugly)

  case $installtype {
    'rpm'     : {
      file { 'splunk rpm':
        source => $installsource,
        path   => "/var/tmp/splunk-${version}-linux-2.6-x86_64.rpm"
      }

      package { 'splunk':
        ensure   => $manage_package,
        provider => rpm,
        source   => "/var/tmp/splunk-${version}-linux-2.6-x86_64.rpm",
        require  => File['splunk rpm']
      }
    }
      default : {
        package { 'splunk': ensure => $manage_package, }
    }
  }



  # change the default password (always a good idea), and accept the license splunk throws at us
  exec { 'splunk initial password change':
    command => "${splunk_homedir}/bin/splunk edit user admin -password ${admin_password} -role admin --accept-license --no-prompt  --answer-yes -auth admin:changeme > ${splunk_homedir}/etc/splunk_pwd_changed-${version}",
    creates => "${splunk_homedir}/etc/splunk_pwd_changed-${version}"
  }

  # setup splunk as a service ..
  # needed for a lot of other types
  exec {'splunk enable boot-start':
    command => "${splunk_homedir}/bin/splunk enable boot-start",
    creates => '/etc/init.d/splunk'
  }

  #setup a /usr/sbin link for the splunk command
  file {'splunk sbin link':
    ensure => $manage_link,
    path   => '/usr/sbin/splunk',
    target => "${splunk_homedir}/bin/splunk"
  }

  #setup a link to /etc/splunk for correct functioning of custom resources
  file {'splunk etc link':
    ensure => $manage_link,
    path   => '/etc/splunk',
    target => "${splunk_homedir}/etc"
  }

  file {'splunk var link':
    ensure => $manage_link,
    path   => '/var/splunk',
    target => "${splunk_homedir}/var"
  }

}