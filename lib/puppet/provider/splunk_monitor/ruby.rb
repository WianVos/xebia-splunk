require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk_ini_file.rb'))

Puppet::Type.type(:splunk_monitor).provide(:ruby, :parent => Puppet::Provider::Splunk_ini_file ) do
  
  #the commands need to be declared here, and cannot be set in the parent provider for some reason
  commands  :cp   => '/bin/cp',
    :mkdir => '/bin/mkdir',
    :touch => '/bin/touch',
    :chmod => '/bin/chmod'
    
  def initialize(value)
    super(value)
    @properties = self.class.properties
  end

  def self.dir_prefix
    "/etc/splunk/apps"
  end

  def self.file_name
    "inputs.conf"
  end

  def self.properties
    ["interval", "disabled", "source", "sourcetype", "whitelist", "blacklist","index", "pollPeriod", "fullEvent", "filesPerDelay", "delayInMills"]
  end

end
