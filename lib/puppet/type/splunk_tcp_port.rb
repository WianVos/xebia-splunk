require 'pathname'

Puppet::Type.newtype(:splunk_tcp_port) do

  desc 'creates and updates splunk ports'

  ensurable do
    desc "splunk tcp port resource state"

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
      fail('invalid splunk tcp uri..value must start with tcp:') unless value =~ /(tcp)/

    end
  end

#  newparam(:stanza_file) do
#    desc 'the stanzafile in which the configuration has to be done'
#    defaultto "/etc/splunk/local/inputs.conf"
#
#  end

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

    desc 'how to set the hostname data'

  end

  newproperty(:queue) do

    desc 'how to set the hostname data'

  end
  newproperty(:queuesize) do

    desc 'how to set the hostname data'

  end
  newproperty(:persistentqueuesize) do

    desc 'how to set the hostname data'

  end
  newproperty(:requireheader) do

    desc 'how to set the hostname data'

  end
  newproperty(:listenonipv6) do

    desc 'how to set the hostname data'

  end
  newproperty(:acceptfrom) do

    desc 'how to set the hostname data'

  end
  newproperty(:rawtcpdonetimeout) do

    desc 'how to set the hostname data'

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

  # a nasty hack i borrowed from Tim Sharpe
  def initialize(*args)
    
    super

    # if this type is called during a puppet run than do a send a notify to the splunk service
    self[:notify] = ["Service[splunk]", "Service[splunkd]", ].select { |ref| catalog.resource(ref) } unless catalog.nil?

  end

end