require 'pathname'

Puppet::Type.newtype(:splunk_license_master) do

  desc 'creates and updates splunk udp ports'

  ensurable do
    desc "splunk search server resource state"

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
  newparam(:port) do
  
  desc 'the port the licensemaster is listening to'
    defaultto "8089"
  end

  newparam(:check_connection) do 
    defaultto true
    newvalues(true,false)
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