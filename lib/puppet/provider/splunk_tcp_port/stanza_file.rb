require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk_stanza.rb'))

Puppet::Type.type(:splunk_tcp_port).provide('tcp_stanza_file', :parent => Puppet::Provider::Splunk_stanza ) do


  def initialize(value)
     super(value)

     @dictionary = self.class.dictionary 
     @resource_identifier = self.class.resource_identifier
     @config_file = self.class.config_file
     
   end
   
   def self.dictionary
     { "connection_host" => "connection_host",
         "queuesize" => "queueSize",
         "queue" => "queue",
         "persistentqueuesize" => "persistentQueueSize",
         "requireheader" => "requireHeader",
         "listenonipv6" => "listenOnIPv6",
         "acceptfrom" => "acceptFrom",
         "rawtcpdonetimeout" => "rawTcpDoneTimeout",
         "source" => "source",
         "sourcetype" => "sourcetype",
         "index" => "index"}
   end
   
   def self.resource_identifier
     /^(tcp)[:]/
   end
   
   def self.config_file
     "/etc/splunk/system/local/inputs.conf"
   end
   
  end