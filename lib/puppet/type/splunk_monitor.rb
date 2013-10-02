Puppet::Type.newtype(:splunk_monitor) do

  ensurable do
          desc "splunk monitor resource state"
      
          defaultto(:present)
      
          newvalue(:present) do
            provider.create
          end
      
          newvalue(:absent) do
            provider.destroy
          end
        end


  newparam(:name, :namevar => true) do
    desc 'monitor to manage from an apps inputs.conf file'
    # namevar should be of the form section/setting
    newvalues(/\S+\/\S+/)
  end
  
  newparam(:app) do
    defaultto('search')
  end
  newproperty(:interval) do
    desc 'the interval setting (applicable to script type monitors)'
    validate do |value|
      fail("interval should not be set if the monitor is not a script type monitor") if value != nil and resource[:name] !~ /script/
    end
  end
  newproperty(:source) do
    desc 'the source setting for this monitor'
  end

  newproperty(:sourcetype) do
    desc 'the sourcetype setting for this monitor'
  end

  newproperty(:index) do
    desc 'the index setting for this monitor'
  end
  newproperty(:disabled) do
    defaultto('0')
    newvalues('1','0')
  end
  newproperty(:whitelist) do
    validate do |value|
      fail("whitelist should not be set if the monitor is not a monitor type monitor") if value != nil and resource[:name] !~ /monitor/
    end
  end
  newproperty(:blacklist) do
    validate do |value|
      fail("blacklist should not be set if the monitor is not a monitor type monitor") if value != nil and resource[:name] !~ /monitor/
    end
  end
  newproperty(:pollperiod) do
    validate do |value|
      fail("pollperiod should not be set if the monitor is not a fschange type monitor") if value != nil and resource[:name] !~ /fschange/
    end
  end
  newproperty(:fullevent) do
    validate do |value|
      fail("fullevent can not be set if the monitor is not a fschange type monitor") if value != nil and resource[:name] !~ /fschange/
    end
  end
  newproperty(:filesperdelay) do
    validate do |value|
      fail("filesperdelay can not be set if the monitor is not a fschange type monitor") if value != nil and resource[:name] !~ /fschange/
    end
  end
  newproperty(:delayinmills) do
    validate do |value|
      fail("delayinmills can not be set if the monitor is not a fschange type monitor") if value != nil and resource[:name] !~ /fschange/
    end
  end
  
  # autorequire section
  autorequire(:file) do
    'splunk etc link'
    'splunk sbin link'
    'splunk var link'
  end



  def initialize(*args)
    super

    # we require the splunk server to be restarted before these settings take effect
    self[:notify] = [ "Service[splunk]","Service[splunkd]",].select { |ref| catalog.resource(ref) } unless catalog.nil?
  end
end
