Puppet::Type.newtype(:splunk_login) do

  desc 'splunk login type'

  # ensurable
    ensurable do
        desc "splunk app resource state"
    
        defaultto(:present)
    
        newvalue(:present) do
          provider.create
        end
    
        newvalue(:absent) do
          self.notify 'the splunk_login provider has no destroy method'
        end
      end

  
  # general properties
 
  newparam(:username, :namevar => true) do
    desc 'splunk admin username to use'
    defaultto :admin
  end

  newparam(:password)do
    desc 'valid password for the splunk admin user'
    defaultto :changeme
  end

 
  
    
  # autorequire
  autorequire(:package) do
    'splunk'
  end
  
  autorequire(:file) do
    'splunk etc link'
    'splunk sbin link'  
    'splunk var link'
  end
  
  autorequire(:exec) do
    'splunk enable boot-start'
    'splunk initial password change'
  end

  
  
  

end