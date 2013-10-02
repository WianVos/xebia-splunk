Puppet::Type.newtype(:splunk_savedsearch) do

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
