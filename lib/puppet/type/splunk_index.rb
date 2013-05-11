require 'pathname'

Puppet::Type.newtype(:splunk_index) do

  desc 'creates and updates indexes'

  ensurable do
        desc "splunk index resource state"
    
        defaultto(:present)
    
        newvalue(:present) do
          provider.create
        end
    
        newvalue(:absent) do
          provider.destroy
        end
      end


  # authenication parameters
 

  newparam(:forceindexpath) do
    desc 'force the change of index paths. This is leads to the loss of all data present in the index'
    defaultto :false
    newvalues(:false, :true)

  end

  # properties
  newparam(:indexname, :namevar => true ) do

    desc 'The name of the index'

  end

  newproperty(:homepath) do


    validate do |value|
        fail('invalid pathname') unless Pathname.new(value).absolute?
      
    end

  end

  newproperty(:coldpath) do

    desc 'the path to the cold data'


    validate do |value|

        fail('invalid pathname') unless Pathname.new(value).absolute?
    end

  end

  newproperty(:thawedpath) do

    desc 'the path to the thawed data'

    
    validate do |value|

        fail('invalid pathname') unless Pathname.new(value).absolute?
    end

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
    ].select { |ref| catalog.resource(ref) }
  end

end