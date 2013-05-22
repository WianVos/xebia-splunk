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
    interval   => 120,
    index      => 'os',
    source     => 'vmstat',
    sourcetype => 'vmstat',
  }

  splunk_monitor { 'fschange:/etc':  }

  splunk_monitor { 'monitor:///var/log':
    blacklist => '(lastlog)',
    index     => 'os',
  }
}