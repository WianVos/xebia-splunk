require 'pathname'

Puppet::Type.newtype(:splunk_splunktcp_port) do

  desc 'creates and updates the settings for the port that the universal forwarders use'

  ensurable do
        desc "splunk splunktcp port resource state"
    
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
      fail('invalid splunk udp uri..value must start with udp:') unless value =~ /(splunktcp)[:][\/]{2}([^:\/])*[:](\d){3,}/

    end
  end
  
  newproperty(:connection_host) do
    
    desc '* "ip" sets the host to the IP address of the system sending the data. 
    * "dns" sets the host to the reverse DNS entry for IP address of the system sending the data.
    * "none" leaves the host as specified in inputs.conf, typically the splunk system hostname.
    * Defaults to "ip".'
    newvalue("dns")
    newvalue("ip")
    newvalue("none")
    defaultto "dns"
    
  end
  
  newproperty(:enables2sheartbeat) do
    desc '* This specifies the keepalive setting for the splunktcp port.
    * This option is used to detect forwarders which may have become unavailable due to network, firewall, etc., problems.
    * Splunk will monitor the connection for presence of heartbeat, and if the heartbeat is not seen for 
      s2sHeartbeatTimeout seconds, it will close the connection.
    * This overrides the default value specified at the global [splunktcp] stanza.'
    
    newvalues("true", "false")
  end
  
  newproperty(:s2sheartbeatTimeout) do
    desc 'heartbeat timeout in seconds'
    defaultto 120
    
  end
   
  newproperty(:compressed) do 
    desc '* Specifies whether receiving compressed data.
    * If set to true, the forwarder port must also have compression turned on.'
    
    newvalues("true", "false")
    end
   
    newproperty(:inputshutdowntimeout) do
      desc ' Used during shutdown to minimize data loss when forwarders are connected to a receiver. 
      During shutdown, the tcp input processor waits for the specified number of seconds and then 
      closes any remaining open connections. If, however, all connections close before the end of 
      the timeout period, shutdown proceeds immediately, without waiting for the timeout.'
      
    end
  
    newproperty(:queuesize) do

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