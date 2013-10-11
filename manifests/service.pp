# service class for splunk server installations
class splunk::service () {


  service { 'splunk': ensure => running, hasrestart => true }

}