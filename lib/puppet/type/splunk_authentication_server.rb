Puppet::Type.newtype(:splunk_authentication_server) do

  desc 'allows for the setup of a ldap server as external authentication method for splunk'

  ensurable do
        desc "splunk authentication server resource state"
    
        defaultto(:present)
    
        newvalue(:present) do
          
          provider.create
          provider.create_splunk_authentication_server
          
        end
    
        newvalue(:absent) do
          
          provider.destroy
          provider.destroy_splunk_authentication_server
          
        end
      end


  # global validation

  # basic parameters

  # parameter settings
  newparam(:host, :namevar => true) do

    desc 'the resolvable hostname of the authentication server'
  end

  newparam(:authentication_file) do
    defaultto '/etc/splunk/system/local/authentication.conf'
  end

  # property settings
  newproperty(:sslenabled) do

    desc 'should SSL be enabled ?'

    defaultto 0

    newvalues[1, 0]

  end

  newproperty(:port) do
    desc 'portnumber to be used'
  end

  newproperty(:binddn) do
    desc 'the DN to use to bind to the authentication server'
  end

  newproperty(:binddnpassword) do
    desc 'the password to the bindDN'
  end

  newproperty(:userbasedn, :array_matching => :all) do
    desc 'the base dn under wich the users can be found. Multiple values can be specified as array'
  end

  newproperty(:userbasefilter) do

    desc 'This is the LDAP search filter you wish to use when searching for users.'

  end

  newproperty(:usernameattribute) do

    desc 'This is the user entry attribute whose value is the username.'
    defaultto "sAMAccountName"

  end
  newproperty(:realnameattribute) do

    desc 'This is the user entry attribute whose value is their real name (human readable).'

    defaultto "cn"

  end
  newproperty(:groupmappingattribute) do

    desc 'This is the user entry attribute whose value is used by group entries to declare membership.'

  end

  newproperty(:groupbasedn) do

    desc 'This is the distinguished names of LDAP entries whose subtrees contain the groups.'

    defaultto 'groups'

  end

  newproperty(:groupbasefilter) do

    desc 'The LDAP search filter Splunk uses when searching for static groups'

  end

  newproperty(:dynamicgroupfilter) do

    desc 'The LDAP search filter Splunk uses when searching for dynamic groups'

  end

  newproperty(:dynamicmemberattribute) do

    desc 'Only configure this if you intend to retrieve dynamic groups on your LDAP server'

  end

  newproperty(:groupnameattribute) do

    desc 'This is the group entry attribute whose value stores the group name.'

    defaultto 'cn'

  end
  newproperty(:groupmemberattribute) do

    desc 'This is the group entry attribute whose values are the groups members'

    defaultto 'member'

  end

  newproperty(:nestedgroups) do

    desc 'Controls whether Splunk will expand nested groups using the memberof extension.'

  end

  newproperty(:charset) do

    desc 'ONLY set this for an LDAP setup that returns non-UTF-8 encoded data. LDAP is supposed to always return UTF-8 encoded
data (See RFC 2251), but some tools incorrectly return other encodings.'

  end

  newproperty(:anonymous_referrals) do

    defaultto 0

    newvalues[1, 0]

  end

  newproperty(:sizelimit) do

    desc 'Limits the amount of entries we request in LDAP search'

  end

  newproperty(:timelimit) do

    desc 'Limits the amount of time in seconds we will wait for an LDAP search request to complete'

  end

  newproperty(:network_timeout) do

    desc 'Limits the amount of time a socket will poll a connection without activity'

  end
  # autorequires
  # we need the splunk package to be installed
  autorequire(:package) do
    'splunk'
  end

  autorequire(:file) do
    'splunk etc link'
    'splunk sbin link'  
    'splunk var link'
  end

  validate do
    fail('host is required when ensure is set to present') if self[:ensure] == :present and self[:host].nil?
    fail('userbasedn is required when ensure is present') if self[:ensure] == :present and self[:userbasedn].nil?
    fail('usernameattribute is required when ensure is present') if self[:ensure] == :present and self[:usernameattribute].nil?
    fail('realnameattribute is required when ensure is present') if self[:ensure] == :present and self[:realnameattribute].nil?
    fail('groupbasedn is required when ensure is present') if self[:ensure] == :present and self[:groupbasedn].nil?
    fail('groupnameattribute is required when ensure is present') if self[:ensure] == :present and self[:groupnameattribute].nil?
    fail('groupmemberattribute is required when ensure is present') if self[:ensure] == :present and self[:groupmemberattribute].nil?
  end

  def initialize(*args)
    
    super
    # add a notify when one of the serivces listed is found in the catalog
    self[:notify] = ["Service[splunk]", "Service[splunkd]"].select { |ref| catalog.resource(ref) } unless catalog.nil?
  end

end