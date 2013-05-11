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

  

  # a nasty hack i borrowed from Tim Sharpe
  def initialize(*args)
    super
    self[:notify] = [
      "Service[splunk]",
      "Service[splunkd]",
    ].select { |ref| catalog.resource(ref) } unless catalog.nil?

    
    
  end

  

end