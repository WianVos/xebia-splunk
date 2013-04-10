# TODO: add roles to map parameter
# TODO: add autorequire of the splunk_authentication_server object
# TODO: add parameters for authentication en authorization file
# TODO: write provider ..
# TODO: notify server from this resource ..
# TODO: add global validation for splunk_authentication_server -> map_role_to

Puppet::Type.newtype(:splunk_role) do

  desc ' allow for the setup of multiple splunk roles '

  ensurable do
        desc "splunk role resource state"
    
        defaultto(:present)
    
        newvalue(:present) do
          provider.create
          provider.create_splunk_role
        end
    
        newvalue(:absent) do
          provider.destroy
          provider.destroy_splunk_role
        end
      end

  #basic parameters

  # parameter settings

  newparam(:role_name, :namevar => true) do
    desc 'name of the role to implement'
    validate do |value|
      fail("invalid role name #{value}") unless value =~ /(role_)[a-zA-Z0-9_]*/
    end
  end

  newparam(:authentication_file) do
    desc 'location of the authentication file, the default value is /etc/splunk/system/local/authentication.conf. This depends on the link between /etc/splunk and $SPLUNK_HOME/etc/system'

    defaultto '/etc/splunk/system/local/authentication.conf'
  end

  newparam(:authorize_file) do
    desc 'location of the authorize file, the default value is /etc/splunk/system/local/authorize.conf. This depends on the link between /etc/splunk and $SPLUNK_HOME/etc/system'
    defaultto '/etc/splunk/system/local/authorize.conf'
  end

  # property settings

  newproperty(:role_map, :array_matching => :all) do

    desc 'ldap groups to map this role to'

    defaultto 'none'

  end

  # splunk authorize.conf generic settings
  newproperty(:importroles, :array_matching => :all) do
    desc 'array list of other roles and their associated capabilities that should be imported'
  end

  newproperty(:srchfilter, :array_matching => :all) do
    desc 'array list of search filters for this Role.'
  end
  newproperty(:srchtimewin) do
    desc 'Maximum time span of a search, in seconds.'
  end
  newproperty(:srchdiskquota) do
    desc 'Maximum amount of disk space (MB) that can be used by search jobs of a user that belongs to this role'
    defaultto 100
  end
  newproperty(:srchjobsquota) do
    desc 'Maximum number of concurrently running historical searches a member of this role can have.'
    defaultto 3
  end
  newproperty(:rtsrchjobsquota) do
    desc 'Maximum number of concurrently running real-time searches a member of this role can have.'
    defaultto 6
  end
  newproperty(:srchmaxtime) do
    desc 'Maximum amount of time that searches of users from this role will be allowed to run.'
    defaultto "100days"
  end
  newproperty(:srchindexesdefault, :array_matching => :all) do
    desc 'array of indexes to search when no index is specified'
  end
  newproperty(:srchindexesallowed, :array_matching => :all) do
    desc 'array of indexes this role is allowed to search'
  end

  ### Properties for Splunk system capabilities
  # the only value here is enabled of nothing

  newproperty(:admin_all_objects) do
    desc 'A role with this capability has access to objects in the system (user objects, search jobs, etc.)'
    validate do |value |
      fail('illegal parameter specified for admin_all_objects') unless value == "enabled"
    end
  end

  newproperty(:change_authentication) do
    desc 'Required to change authentication settings through the various authentication endpoints.'
    validate do |value|
      fail('illegal parameter specified for change_authentication') unless value == "enabled"
    end
  end

  newproperty(:change_own_password) do
    desc 'Self explanatory. Some auth systems prefer to have passwords be immutable for some users.'
    validate do |value|
      fail('illegal parameter specified for change_own_password') unless value == "enabled"
    end
  end
  newproperty(:delete_by_keyword) do
    desc 'Required to use the delete search operator. Note that this does not actually delete the raw data on disk.'
    validate do |value|
      fail('illegal parameter specified for delete_by_keyword') unless value == "enabled"
    end
  end
  newproperty(:edit_deployment_client) do
    desc 'Self explanatory. The deployment client admin endpoint requires this cap for edit'
    validate do |value|
      fail('illegal parameter specified for edit_deployment_client') unless value == "enabled"
    end
  end

  newproperty(:edit_deployment_server) do
    desc ''
    validate do |value|
      fail('illegal parameter specified for edit_deployment_server') unless value == "enabled"
    end
  end

  newproperty(:edit_dist_peer) do
    desc 'Required to add and edit peers for distributed search'
    validate do |value|
      fail('illegal parameter specified for edit_dist_peer') unless value == "enabled"
    end
  end

  newproperty(:edit_forwarders) do
    desc 'Required to edit settings for forwarding data.'
    validate do |value|
      fail('illegal parameter specified for edit_forwarders') unless value == "enabled"
    end
  end

  newproperty(:edit_httpauths) do
    desc 'Required to edit and end user sessions through the httpauth-tokens endpoint'
    validate do |value|
      fail('illegal parameter specified for edit_httpauths') unless value == "enabled"
    end
  end

  newproperty(:edit_input_defaults) do
    desc 'Required to change the default hostname for input data in the server settings endpoint.'
    validate do |value|
      fail('illegal parameter specified for edit_input_defaults') unless value == "enabled"
    end
  end

  newproperty(:edit_monitor) do
    desc 'Required to add inputs and edit settings for monitoring files.'
    validate do |value|
      fail('illegal parameter specified for edit_monitor') unless value == "enabled"
    end
  end

  newproperty(:edit_roles) do
    desc 'Required to edit roles as well as change the mappings from users to roles.'
    validate do |value|
      fail('illegal parameter specified for edit_roles') unless value == "enabled"
    end
  end

  newproperty(:edit_scripted) do
    desc 'Required to create and edit scripted inputs.'
    validate do |value|
      fail('illegal parameter specified for edit_scripted') unless value == "enabled"
    end
  end

  newproperty(:edit_search_server) do
    desc 'Required to edit general distributed search settings like timeouts, heartbeats, and blacklists'
    validate do |value|
      fail('illegal parameter specified for edit_search_server') unless value == "enabled"
    end
  end
  newproperty(:edit_server) do
    desc 'Required to edit general server settings such as the server name, log levels, etc.'
    validate do |value|
      fail('illegal parameter specified for edit_server') unless value == "enabled"
    end
  end
  newproperty(:edit_splunktcp) do
    desc 'Required to change settings for receiving TCP input from another Splunk instance.'
    validate do |value|
      fail('illegal parameter specified for edit_splunktcp') unless value == "enabled"
    end
  end
  newproperty(:edit_splunktcp_ssl) do
    desc 'Required to list or edit any SSL specific settings for Splunk TCP input.'
    validate do |value|
      fail('illegal parameter specified for edit_splunktcp_ssl') unless value == "enabled"
    end
  end
  newproperty(:edit_tcp) do
    desc 'Required to change settings for receiving general TCP inputs.'
    validate do |value|
      fail('illegal parameter specified for edit_tcp') unless value == "enabled"
    end
  end
  newproperty(:edit_udp) do
    desc 'Required to change settings for UDP inputs.'
    validate do |value|
      fail('illegal parameter specified for edit_udp') unless value == "enabled"
    end
  end

  newproperty(:edit_user) do
    desc 'Required to create, edit, or remove users'
    validate do |value|
      fail('illegal parameter specified for edit_user') unless value == "enabled"
    end
  end
  newproperty(:edit_web_settings) do
    desc 'Required to change the settings for web.conf through the system settings endpoint.'
    validate do |value|
      fail('illegal parameter specified for edit_web_settings') unless value == "enabled"
    end
  end
  newproperty(:get_metadata) do
    desc 'Required to change the settings for web.conf through the system settings endpoint.'
    validate do |value|
      fail('illegal parameter specified for get_metadata') unless value == "enabled"
    end
  end
  newproperty(:get_typeahead) do
    desc 'Required for typeahead. This includes the typeahead endpoint and the typeahead search processor.'
    validate do |value|
      fail('illegal parameter specified for get_typeahead') unless value == "enabled"
    end
  end
  newproperty(:input_file) do
    desc 'Required for inputcsv (except for dispatch=t mode) and inputlookup'
    validate do |value|
      fail('illegal parameter specified for input_file') unless value == "enabled"
    end
  end
  newproperty(:indexes_edit) do
    desc 'Required to change any index settings like file size and memory limits.'
    validate do |value|
      fail('illegal parameter specified for indexes_edit') unless value == "enabled"
    end
  end
  newproperty(:license_tab) do
    desc 'Required to access and change the license.'
    validate do |value|
      fail('illegal parameter specified for license_tab') unless value == "enabled"
    end
  end
  newproperty(:list_forwarders) do
    desc 'Required to show settings for forwarding data.'
    validate do |value|
      fail('illegal parameter specified for list_forwarders') unless value == "enabled"
    end
  end

  newproperty(:list_httpauths) do
    desc 'Required to list user sessions through the httpauth-tokens endpoint.'
    validate do |value|
      fail('illegal parameter specified for list_httpauths') unless value == "enabled"
    end
  end
  newproperty(:list_inputs) do
    desc 'Required to view the list of various inputs.'
    validate do |value|
      fail('illegal parameter specified for list_inputs') unless value == "enabled"
    end
  end
  newproperty(:output_file) do
    desc 'Required for outputcsv (except for dispatch=t mode) and outputlookup'
    validate do |value|
      fail('illegal parameter specified for output_file') unless value == "enabled"
    end
  end
  newproperty(:request_remote_tok) do
    desc 'Required to get a remote authentication token'
    validate do |value|
      fail('illegal parameter specified for request_remote_tok') unless value == "enabled"
    end
  end
  newproperty(:rest_apps_management) do
    desc 'Required to edit settings for entries and categories in the python remote apps handler.'
    validate do |value|
      fail('illegal parameter specified for rest_apps_management') unless value == "enabled"
    end
  end
  newproperty(:rest_apps_view) do
    desc 'Required to list various properties in the python remote apps handler.'
    validate do |value|
      fail('illegal parameter specified for rest_apps_view') unless value == "enabled"
    end
  end
  newproperty(:rest_properties_get) do
    desc 'Required to get information from the services/properties endpoint.'
    validate do |value|
      fail('illegal parameter specified for rest_properties_get') unless value == "enabled"
    end
  end
  newproperty(:rest_properties_set) do
    desc 'Required to edit the services/properties endpoint.'
    validate do |value|
      fail('illegal parameter specified for rest_properties_set') unless value == "enabled"
    end
  end
  newproperty(:restart_splunkd) do
    desc 'Required to restart Splunk through the server control handler.'
    validate do |value|
      fail('illegal parameter specified for restart_splunkd') unless value == "enabled"
    end
  end
  newproperty(:rtsearch) do
    desc 'Required to run a realtime search.'
    validate do |value|
      fail('illegal parameter specified for rtsearch') unless value == "enabled"
    end
  end

  newproperty(:run_debug_commands) do
    desc 'Required to run debugging commands like summarize'
    validate do |value|
      fail('illegal parameter specified for run_debug_commands') unless value == "enabled"
    end
  end
  newproperty(:schedule_search) do
    desc 'Required to schedule saved searches.'
    validate do |value|
      fail('illegal parameter specified for schedule_search') unless value == "enabled"
    end
  end
  newproperty(:search) do
    desc 'Self explanatory - required to run a search.'
    validate do |value|
      fail('illegal parameter specified for admin_all_objects') unless value == "enabled"
    end
  end
  newproperty(:use_file_operator) do
    desc 'Required to use the file search operator.'
    validate do |value|
      fail('illegal parameter specified for use_file_operator') unless value == "enabled"
    end
  end

  # autorequires
  # we need the splunk package to be installed
  autorequire(:package) do
    'splunk'
  end

  # require splunk etc file link
  autorequire(:file) do
    'splunk etc link'
    'splunk sbin link'
    'splunk var link'
  end

  # require any and all splunk_authentication_server resources  
  autorequire(:splunk_authentication_server) do
    catalog.resource_refs.select {|ref| ref.to_s =~ /splunk_authentication_server/i }
  end
  
  def initialize(*args)

    super
    # add a notify when one of the serivces listed is found in the catalog
    self[:notify] = ["Service[splunk]", "Service[splunkd]", ].select { |ref| catalog.resource(ref) } unless catalog.nil?

    
  end
end