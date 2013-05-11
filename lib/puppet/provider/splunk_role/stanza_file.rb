require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk_stanza.rb'))

Puppet::Type.type(:splunk_role).provide('stanza_file', :parent => Puppet::Provider::Splunk_stanza ) do
  def initialize(value)
    super(value)

    @dictionary = self.class.dictionary
    @resource_identifier = self.class.resource_identifier
    @config_file = self.class.config_file

  end

  def self.dictionary
    { "importroles" => "importRoles",
      "srchfilter" => "srchFilter",
      "srchtimewin" => "srchTimeWin",
      "srchdiskquota" => "srchDiskQuota",
      "srchjobsquota" => "srchJobsQuota",
      "rtsrchjobsquota" => "rtSrchJobsQuota",
      "srchmaxtime" => "srchMaxTime",
      "srchindexesdefault" => "srchIndexesDefault",
      "srchindexesallowed" => "srchIndexesAllowed",
      "admin_all_objects" => "admin_all_objects",
      "change_authentication" => "change_authentication",
      "change_own_password" => "change_own_password",
      "delete_by_keyword" => "delete_by_keyword",
      "edit_deployment_client" => "edit_deployment_client",
      "edit_deployment_server" => "edit_deployment_server",
      "edit_dist_peer" => "edit_dist_peer",
      "edit_forwarders" => "edit_forwarders",
      "edit_httpauths" => "edit_httpauths",
      "edit_input_defaults" => "edit_input_defaults",
      "edit_monitor" => "edit_monitor",
      "edit_roles" => "edit_roles",
      "edit_scripted" => "edit_scripted",
      "edit_search_server" => "edit_search_server",
      "edit_server" => "edit_server",
      "edit_splunktcp" => "edit_splunktcp",
      "edit_splunktcp_ssl" => "edit_splunktcp_ssl",
      "edit_tcp" => "edit_tcp",
      "edit_udp" => "edit_udp",
      "edit_user" => "edit_user",
      "edit_web_settings" => "edit_web_settings",
      "get_metadata" => "get_metadata",
      "get_typeahead" => "get_typeahead",
      "input_file" => "input_file",
      "indexes_edit" => "indexes_edit",
      "license_tab" => "license_tab",
      "list_forwarders" => "list_forwarders",
      "list_httpauths" => "list_httpauths",
      "list_inputs" => "list_inputs",
      "output_file" => "output_file",
      "request_remote_tok" => "request_remote_tok",
      "rest_apps_management" => "rest_apps_management",
      "rest_apps_view" => "rest_apps_view",
      "rest_properties_get" => "rest_properties_get",
      "rest_properties_set" => "rest_properties_set",
      "restart_splunkd" => "restart_splunkd",
      "rtsearch" => "rtsearch",
      "run_debug_commands" => "run_debug_commands",
      "schedule_search" => "schedule_search",
      "search" => "search",
      "use_file_operator" => "use_file_operator",
    }

  end

  def self.resource_identifier
    /(role_)/
  end

  def self.config_file
    "/etc/splunk/system/local/authorize.conf"
  end

  def create_splunk_role
    unless resource[:role_map].nil?

      authentication_stanza = Stanza.new("/etc/splunk/system/local/authentication.conf")
      valid_role_map = authentication_stanza.get_element_property("authentication", "authSettings")
      authentication_stanza.set_element_property("roleMap_#{valid_role_map}", "#{resource[:name].gsub(/role_/, '')}", "#{resource[:role_map].join(';')}" )

    end
  end

  def destroy_splunk_role
    unless resource[:role_map].nil?

      authentication_stanza = Stanza.new("/etc/splunk/system/local/authentication.conf")
      valid_role_map = authentication_stanza.get_element_property("authentication", "authSettings")
      authentication_stanza.delete_element_property("roleMap_#{valid_role_map}", "#{resource[:name].gsub(/role_/, '')}")

    end
  end

  def role_map
    unless resource[:role_map] == 'none'

      authentication_stanza = Stanza.new("/etc/splunk/system/local/authentication.conf")
      valid_role_map = authentication_stanza.get_element_property("authentication", "authSettings")
      role_map = authentication_stanza.get_element_property("roleMap_#{valid_role_map}", "#{resource[:name].gsub(/role_/, '')}")
      return role_map.split(';') unless role_map.nil?
    else
      'none'
    end
  end

  def role_map=(value)

    authentication_stanza = Stanza.new("/etc/splunk/system/local/authentication.conf")
    valid_role_map = authentication_stanza.get_element_property("authentication", "authSettings")
    authentication_stanza.set_element_property("roleMap_#{valid_role_map}", "#{resource[:name].gsub(/role_/, '')}", "#{resource[:role_map].join(';')}" )

  end
end