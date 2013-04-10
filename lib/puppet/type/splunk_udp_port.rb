require 'pathname'

Puppet::Type.newtype(:splunk_udp_port) do

  desc 'creates and updates splunk udp ports'

  ensurable do
        desc "splunk udp port resource state"
    
        defaultto(:present)
    
        newvalue(:present) do
          provider.create
        end
    
        newvalue(:absent) do
          provider.destroy
        end
      end


  # properties
  newparam(:name, :namevar => true ) do

    desc 'the splunk uri for the port. Must look like tcp://:portnr or tcp:/<hostname>/:portnumber'
    validate do |value|
      fail('invalid splunk udp uri..value must start with udp:') unless value =~ /(udp)/

    end
  end
  
  

  newproperty(:index) do

    desc 'the index where the data is written to'

  end

  newproperty(:source) do

    desc 'the source of the incomming data'

  end

  newproperty(:sourcetype) do

    desc 'the sourcetype of the incomming data'

  end

  newproperty(:connection_host) do



  end
  newproperty(:queue) do

  end
  newproperty(:queuesize) do

  end
  newproperty(:persistentqueuesize) do


  end
  newproperty(:requireheader) do


  end
  newproperty(:listenonipv6) do


  end
  newproperty(:acceptfrom) do


  end

  #autorequires
  autorequire(:package) do
    'splunk'
  end

  autorequire(:file) do
    'splunk etc link'
    'splunk sbin link'
  end

  # a nasty hack i borrowed from Tim Sharpe
  def initialize(*args)
    super
    self[:notify] = [
      "Service[splunk]",
      "Service[splunkd]",
    ].select { |ref| catalog.resource(ref) }
  end

end