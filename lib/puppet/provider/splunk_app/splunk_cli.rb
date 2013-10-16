require 'pathname'
require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk.rb'))

Puppet::Type.type(:splunk_app).provide(:splunk_cli, :parent => Puppet::Provider::Splunk ) do

  has_feature :visibility

  confine :osfamily => [:redhat, :ubuntu]
  confine :exists => "/opt/splunk"

  commands :splunk => "splunk"

  # one day i'm gonna find out why the fuck this is not working .. but for now.. 
  def self.instances
    args = []

    args << "app"
    result = splunk_exec("list", args)

#    command="splunk list app -auth admin:test123"
#    result = `#{command}`

    result.each do |line|

      configured = :true
      enabled = :true
      visible = :true

      appname, config_param, enabled_param, visible_param = line.delete("\n").split

      configured = :false unless config_param == "CONFIGURED"
      enabled = :false unless enabled_param == "ENABLED"
      visible = :false unless visible_param == "VISIBLE"

      new( :name => appname,
      :configured => configured,
      :enabled => enabled,
      :visible => visible,
      :ensure => :present )

    end
  end
 # def exists?
 #    @property_hash[:ensure] == :present
 #  end
  def create

    args = []

    install_file = get_install_file?

    args << "app"
    args << "#{install_file}"

    if install_file != nil
      splunk_exec("install", args, splunkd_running=true)
      visible=("#{resource[:visible]}")
      enabled=("#{resource[:enabled]}")  
    else
      self.notice "installfile not set. Unable to install the app. Beter luck next time"
    end

  end

  def destroy

    args = []

    args << "app"
    args << "#{resource[:name]}"

    splunk_exec("remove", args, splunkd_running=true)

  end

  def exists?
    splunk_resource_exists?(name="#{resource[:name]}", type="app")
  end

  def get_install_file?
    "#{resource[:tmp_fs]}/#{resource[:name]}/#{File.basename(resource[:source])}"
  end

  def enabled
    args = []
      
    args << "app"
    args << "#{resource[:name]}"
    
    enabled = :true
    
    appname, config_param, enabled_param, visible_param = splunk_exec("list", args).delete("\n").split
    
    enabled = :false unless enabled_param == "ENABLED"
    
    return enabled
    
  end

  def visible
    
    args = []
      
    args << "app"
    args << "#{resource[:name]}"
        
    visible = :true
        
    appname, config_param, enabled_param, visible_param = splunk_exec("list", args).delete("\n").split
        
    visible = :false unless visible_param == "VISIBLE"
    return visible
    
  end

  def visible=(value)
    args = []

    args << "app"
    args << "#{resource[:name]}"
    args << "-visible #{resource[:visible]}"

    splunk_exec("edit", args)

  end

  def enabled=(value)
    args = []

    args << "app"
    args << "#{resource[:name]}"
    
    if resource[:enabled] == :true
      splunk_command = "enable"
    else
      splunk_command = "disable"
    end

    splunk_exec("#{splunk_command}", args)

  end

end