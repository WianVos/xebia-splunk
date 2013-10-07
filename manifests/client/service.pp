#class splunk::client::service
# the class around the splunk service
class splunk::client::service () {

service { 'splunk': ensure => running, hasrestart => true }

}