class splunk::config::searchhead () {
  #   test clause for puppet_config type/resource


   splunk_license { 'Splunk Enterprise':
    ensure => present,
    source => 'puppet:///modules/splunk/licenses/splunk10GBKadaster.license',
  }


}
