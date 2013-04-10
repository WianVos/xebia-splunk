require 'pathname'

Puppet::Type.newtype(:splunk_config) do

  desc 'custom type to enable the configuration of splunk through the puppet dsl'

  newparam(:name, :namevar => true) do
  end

  # newparam(:user) do
  #    desc 'splunk admin user to use'
  #    defaultto :admin
  #  end
  #
  #  newparam(:password)do
  #    desc 'valid password for the splunk admin user'
  #    defaultto :changeme
  #  end

  newproperty(:datastore) do
    'localtion of the splunk datastore'
    validate do |value|
      fail('invalid pathname') unless Pathname.new(value).absolute?
    end

  end

  newproperty(:hostname) do
  end

  newproperty(:webport) do

    desc 'the port on wich splunk web will be responding'

    defaultto "8000"

    validate do |value|
      fail('invalid portnumber') unless value =~ /^-?[0-9]+$/
    end
  end

  newproperty(:splunkport) do

    desc 'the splunk management port'

    defaultto "8089"

    validate do |value|
      fail('invalid portnumber') unless value =~ /^-?[0-9]+$/
    end
  end

  newproperty(:minfreemb) do

    desc 'sets the minimum amount of free space for the splund index data dir'

    defaultto :"500"

    validate do |value|
      fail('invalid parameter for minfreemb') unless value =~ /^-?[0-9]+$/
    end

  end

  # autorequires
  # we need the splunk package to be installed
  autorequire(:package) do
    'splunk'
  end

  # if the datastore is going to be set then we need it to be there .. or else ... horrible things will happen
  autorequire(:file) do
    self[:datastore] if self[:datastore] and Pathname.new(self[:datastore]).absolute?
    'splunk etc link'
    'splunk sbin link'
    'splunk var link'
  end

  autorequire(:exec) do
    'splunk enable boot-start'
    'splunk initial password change'
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
    ].select { |ref| catalog.resource(ref) }

  end

end
