require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk_stanza.rb'))

Puppet::Type.type(:splunk_splunktcp_port).provide('splunktcp_stanza_file', :parent => Puppet::Provider::Splunk_stanza ) do

#  
  def initialize(value)
     super(value)
     
     @dictionary = self.class.dictionary
     @resource_identifier = self.class.resource_identifier
     @config_file = self.class.config_file
     
   end
   
   def self.dictionary
     { "connection_host" => "connection_host",
       "queuesize" => "queueSize",
       "lul"  => "lulman",
       "listenonipv6" => "listenOnIPv6",
       "acceptfrom" => "acceptFrom",
       "enables2sheartbeat" => "enableS2SHeartbeat",
       "s2sheartbeattimeout" => "s2sHeartbeatTimeout",
       "compressed"  => "compressed",
       "inputshutdowntimeout" => "inputShutdownTimeout", 
       }
   end
   
   def self.resource_identifier
     /(splunktcp)/
   end
   
   def self.config_file
     "/etc/splunk/system/local/inputs.conf"
   end
   
  end