require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk.rb'))
  
Puppet::Type.type(:splunk_config).provide(:splunk_cli, :parent => Puppet::Provider::Splunk ) do
  
  confine :osfamily => [:redhat, :ubuntu]
  
  commands :splunk => "splunk"
  
  #parameter getters and setters
  #datastore params
  def datastore
    result = splunk_exec("show",["datastore-dir"])
    result = result.to_s.split(':')[1].strip
    return result
  end
  
  def datastore=(value)
    args = []
    args << "datastore-dir #{resource[:datastore]}"
    result = splunk_exec("set", args)
  end
  
  # default-hostname hostname parameter
  def hostname
    result = splunk_exec("show",['default-hostname'])
    result = result.to_s.split(':')[1].strip.chomp(".")
    return result
  end
  
  def hostname=(value)
    args = []
    args << "default-hostname #{resource[:hostname]}"
    result = splunk_exec("set", args)
  end
  
  # webport 
  def webport
    result = splunk_exec("show",['web-port'])
    result = result.to_s.split(':')[1].strip.chomp(".")
    return result
  end
  
  def webport=(value)
    args = []
    args << "web-port #{resource[:webport]}"
    result = splunk_exec("set", args)
  end
  
  # splunkd-port 
  def splunkport
    result = splunk_exec("show",['splunkd-port'])
    result = result.to_s.split(':')[1].strip.chomp(".")
    return result
  end
  
  def splunkport=(value)
    args = []
    args << "splunkd-port #{resource[:splunkport]}"
    result = splunk_exec("set", args)
  end
  
  # minfreemb
  def minfreemb
    result = splunk_exec("show",['minfreemb'])
    result = result.to_s.split()[13].strip.chomp(".")
    return result
  end
  
  def minfreemb=(value)
    args = []
    args << "minfreemb #{resource[:minfreemb]}"
    result = splunk_exec("set", args)
  end
  
  # bootstart 
  def bootstart
    
   result = "disable"
    
    if File.exist?('/etc/init.d/splunk') 
      result = "enable"
    end
    
    return result
  end
  
  def bootstart=(value)
    args = []   
    args << "boot-start"
    result = splunk_enable(args, sub_command = "#{resource[:bootstart]}")
  end

end