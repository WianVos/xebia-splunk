require 'pathname'

Puppet::Type.newtype(:splunk_search_server) do

  desc 'adds a splink license master on a license-localslave'

  ensurable do
    desc "splunk license master resource state"

    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end
  end

  # properties
  newparam(:servername, :namevar => true ) do

  end

  newparam(:check_connection) do 
    defaultto true
    newvalues(true,false)
  end
  
  newproperty(:port) do

    desc 'the index where the data is written to'

  end

  newparam(:remoteuser) do
    defaultto "admin"
    desc 'the username to use in communication to the remote server'

  end

  newparam(:remotepassword) do
    desc 'the password to use in the communication to the remote server'
  end

  #autorequires
  autorequire(:package) do
    'splunk'
  end

  autorequire(:file) do
    'splunk etc link'
    'splunk sbin link'
    'splunk var link'
  end

  autorequire(:splunk_login) do
    'admin'
  end

  autorequire(:splunk_check_connection) do
    @splunk_check_connection_resource
  end

  # a nasty hack i borrowed from Tim Sharpe
  def initialize(*args)
    super
    self[:notify] = [
      "Service[splunk]",
      "Service[splunkd]",
    ].select { |ref| catalog.resource(ref) } unless catalog.nil?

    @splunk_check_connection_resource = nil
    
    @splunk_check_connection_resource = check_connection(args[0].to_hash[:servername],args[0].to_hash[:port]) unless args[0].to_hash[:check_connection] == false
    
  end

  def check_connection(host,port)

    # add a connection check to the catalog ..

    

    params = { :name => "#{host}/#{port} lm",
      :host => "#{host}",
      :ensure => "present",
      :port => "#{port}",
      
    }

    resource = Puppet::Type.type(:splunk_check_connection).new(params)
    catalog = Puppet::Resource::Catalog.new
    catalog.add_resource resource
    catalog.apply

    splunk_check_connection_resource =  "#{host}/#{port} ss"

    return splunk_check_connection_resource

  end

end