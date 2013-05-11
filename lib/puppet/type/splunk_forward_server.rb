Puppet::Type.newtype(:splunk_forward_server) do

  desc 'adds a splunk forward server'

  ensurable do
    desc "splunk forward server resource state"

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
  
  newproperty(:port) do

    desc 'port where data is written to'

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