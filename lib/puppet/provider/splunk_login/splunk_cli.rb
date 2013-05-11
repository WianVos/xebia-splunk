require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk.rb'))

Puppet::Type.type(:splunk_login).provide(:splunk_cli, :parent => Puppet::Provider::Splunk ) do

  # this provider is confined to ubuntu and redhat ...

  confine :osfamily => [:redhat, :ubuntu]

  # only allow this provider to be used when we find the splunk command in the $PATH

  commands :splunk => "splunk"

  def exists?

    # make sure splunk is running, for we cannot login to a not running system
    splunkd_ensure_status(running=true)

    # splunk commands need for a valid credential file to be in $HOME/.splunk directory
    # using the splunk list command with a valid --auth parameter forces that

    command = "splunk list app -auth #{resource[:username]}:#{resource[:password]} --accept-license --no-prompt "

    self.debug "#{command}"
    
    result = `#{command}`
    
    self.debug result
    
    self.fail result unless $?.exitstatus == 0
    
    return true

  end

  def create


    raise Puppet::Error, "unable to login to splunk instance" 
    
  end

end