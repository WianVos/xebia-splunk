class splunk::client::config ($admin_password = $splunk::admin_password, $splunk_admin_port = $splunk::splunk_admin_port) {
  # flow controll
  Splunk_login['admin']
   -> Splunk_app['Splunk_TA_nix']
   -> Splunk_monitor[ 'script://./bin/vmstat.sh',
                      'fschange:/etc',
                      'monitor:///var/log']


  Splunk_monitor {
    app      => 'Splunk_TA_nix',
    disabled => 0,
    index => 'os'
  }

  # resources
  splunk_login { 'admin': password => $admin_password }

  splunk_app { 'Splunk_TA_nix':
    ensure => present,
    source  => 'puppet:///modules/splunk/apps/Splunk_TA_nix.tar.gz',
    enabled => true,
    visible => true,
    require => Splunk_login['admin']
  }

  splunk_monitor { 'script://./bin/vmstat.sh':
    ensure => present,
    interval   => 30,
    index      => 'os',
    source     => 'vmstat',
    sourcetype => 'vmstat',
  }
  splunk_monitor { 'script://./bin/iostat.sh':
    ensure => present,
    interval   => 30,
    index      => 'os',
    source     => 'iostat',
    sourcetype => 'iostat',
  }
  splunk_monitor { 'script://./bin/ps.sh':
    ensure => present,
    interval   => 30,
    index      => 'os',
    source     => 'ps',
    sourcetype => 'ps',
  }
  splunk_monitor { 'script://./bin/top.sh':
    ensure => present,
    interval   => 30,
    index      => 'os',
    source     => 'top',
    sourcetype => 'top',
  }
  splunk_monitor { 'script://./bin/protocol.sh':
    ensure => present,
    interval   => 30,
    index      => 'os',
    source     => 'protocol',
    sourcetype => 'protocol',
  }
  splunk_monitor { 'script://./bin/openPorts.sh':
    ensure => present,
    interval   => 30,
    index      => 'os',
    source     => 'openPorts',
    sourcetype => 'openPorts',
  }
  splunk_monitor { 'script://./bin/time.sh':
    ensure => present,
    interval   => 30,
    index      => 'os',
    source     => 'time',
    sourcetype => 'time',
  }

  splunk_monitor { 'script://./bin/lsof.sh':
    ensure => present,
    interval   => 30,
    index      => 'os',
    source     => 'lsof',
    sourcetype => 'lsof',
  }



  splunk_monitor { 'fschange:/etc':  }

  splunk_monitor { 'monitor:///var/log':
    blacklist => '(lastlog)',
    index     => 'os',
  }

}