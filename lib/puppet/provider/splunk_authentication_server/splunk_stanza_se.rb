require 'pathname'
require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk_stanza_se.rb'))

Puppet::Type.type(:splunk_authentication_server).provide(:splunk_stanza_se, :parent => Puppet::Provider::Splunk_stanza_se ) do
  def initialize(value)
    super(value)

    @dictionary = self.class.dictionary
    @config_file = self.class.config_file

  end

  def self.dictionary
    {  "binddn"                 => "bindDN",
      "sslenabled"              => "SSLEnabled",
      "binddnpassword"          => "bindDNpassword",
      "userbasedn"              => "userBaseDN",
      "host"                    => "host",
      "port"                    => "port",
      "userbasefilter"          => "userBaseFilter",
      "usernameattribute"       => "userNameAttribute",
      "realnameattribute"       => "realNameAttribute",
      "groupmappingattribute"   => "groupMappingAttribute",
      "groupbasedn"             => "groupBaseDN",
      "groupbasefilter"         => "groupBaseFilter",
      "dynamicgroupfilter"      => "dynamicGroupFilter",
      "dynamicmemberattribute"  => "dynamicMemberAttribute",
      "groupnameattribute"      => "groupNameAttribute",
      "groupmemberattribute"    => "groupMemberAttribute",
      "nestedgroups"            => "nestedGroups",
      "charset"                 => "charset",
      "anonymous_referrals"     => "anonymous_referrals",
      "sizelimit"               => "sizelimit",
      "timelimit"               => "timelimit",
      "network_timeout"         => "network_timeout",
    }
  end

  def self.config_file
    "/etc/splunk/system/local/authentication.conf"
  end

  def create_splunk_authentication_server

    options = { "authSettings" => "#{resource[:name]}", "authType"=> "LDAP" }
    @stanza.update_resource("authentication", options)
    @stanza.add_stanza_element("roleMap_#{resource[:name]}", options=nil)

  end

  def exists_splunk_authentication_server
    @stanza.get_element_property("authentication", "#{resource[:name]}")
  end

  def destroy_splunk_authentication_server
    @stanza.update_resource("authentication", {"authType" => "SPLUNK"})
    @stanza.remove_resource("roleMap_#{resource[:name]}")
  end
  #  def initialize(value={})
  #
  #    super(value)
  #
  #    # initialize the config hash (this is somewhat troublesome because the resource hash is not complete during initialization of the provider class
  #    @Property_hash = get_conf_hash
  #
  #    # get all the property's from the dictionary hash and loop over them
  #    # once we have those we'll use meta programming (cool .. i always wanted to say that .. ) to add specialized puppet providertype validators and setters
  #    get_dictionary.each_key do | prop |
  #
  #      # use instance eval to dynamicly add code to the class ..
  #      self.instance_eval %Q{
  #
  #        # add a method with the name #{prop}
  #        def #{prop}
  #          # get the property from the authentication hash
  #          result = @Property_hash["#{resource[:name]}"]["#{translate_prop("#{prop}", direction="b")}"]
  #
  #          # check if the result is not nil
  #          unless result == nil
  #            #when the result contains a ; it has to be presented to the type as array
  #            if result.include?(';')
  #              result = result.split(';')
  #              end
  #          end
  #
  #          # and return the fruit of our labor
  #          return result
  #        end
  #
  #        # add setter method
  #        def #{prop}=(value)
  #
  #          # if value is an array convert it to a ; separated string
  #          if value.class == Array
  #            value = value.join(';')
  #          end
  #
  #          # add the value to the hash in the correct place
  #          @Property_hash["#{resource[:name]}"]["#{translate_prop("#{prop}", direction="b")}"] = value
  #        end
  #       }
  #    end
  #  end
  #
  #  # create the resource whith the approriate stanza
  #  def create
  #
  #    # check if the hash has and entry for our resource .. if not create one
  #    unless @Property_hash.has_key?("#{resource[:name]}")
  #
  #      @Property_hash["#{resource[:name]}"] = Hash.new
  #
  #    end
  #
  #    # check if the hash has an entry for the roleMap
  #    unless @Property_hash.has_key?("roleMap_#{resource[:name]}")
  #
  #          @Property_hash["roleMap_#{resource[:name]}"] = Hash.new
  #
  #        end
  #
  #    # same thing but for the authentication stanza
  #    unless @Property_hash.has_key?("authentication")
  #
  #      @Property_hash["authentication"] = Hash.new()
  #
  #    end
  #
  #    # translate the resource property's to a viable hash and add it to the authenticaton hash
  #    @Property_hash["#{resource[:name]}"] = get_property_hash
  #
  #    # set the much needed authentication stanza to something usefull  .. tell splunk to use the authentication resource
  #    @Property_hash["authentication"]["authSettings"] = "#{resource[:name]}"
  #    @Property_hash["authentication"]["authType"] = "LDAP"
  #
  #  end
  #
  #  def destroy
  #
  #    # remove all of our stuff from the hash
  #    @Property_hash.delete("#{resource[:name]}")
  #    @Property_hash.delete("roleMap_#{resource[:name]}")
  #
  #    @Property_hash["authentication"].delete("authSettings")
  #
  #    # set the authType parameter back to Splunk
  #    @Property_hash["authentication"]["authType"] = "Splunk"
  #
  #  end
  #
  #  def exists?
  #
  #    # fully initialze the authentication hash
  #    # the exists method always gets called first .. so this should work
  #    @Property_hash = get_conf_hash
  #
  #    # check the authentication hash for the right parameters that represent our resource
  #    @Property_hash.has_key?("#{resource[:name]}") and @Property_hash.has_key?("roleMap_#{resource[:name]}")
  #
  #  end
  #
  #  def flush
  #
  #    # flush is the very last method to be called so this will flush the augmented hash back to the file
  #    write_conf_hash(confhash=@Property_hash)
  #  end
  #
  #  private
  #
  #  def get_conf_hash
  #
  #    # use a helper method to return a hash whith the contence of the authentication file
  #    splunk_conf_to_hash(filename="#{resource[:authentication_file]}")
  #  end
  #
  #  def write_conf_hash(confhash)
  #
  #    # use a helper method to write the authentication hash back to the file
  #    splunk_hash_to_conf(confhash,"#{resource[:authentication_file]}" )
  #  end
  #
  #  def get_dictionary
  #
  #    # return a dictornary hash of the available resource parameters and their splunk counterparts .
  #    # I hate camelcase.. seriously ..
  #    {  "binddn"                 => "bindDN",
  #      "sslenabled"              => "SSLEnabled",
  #      "binddnpassword"          => "bindDNpassword",
  #      "userbasedn"              => "userBaseDN",
  #      "host"                    => "host",
  #      "port"                    => "port",
  #      "userbasefilter"          => "userBaseFilter",
  #      "usernameattribute"       => "userNameAttribute",
  #      "realnameattribute"       => "realNameAttribute",
  #      "groupmappingattribute"   => "groupMappingAttribute",
  #      "groupbasedn"             => "groupBaseDN",
  #      "groupbasefilter"         => "groupBaseFilter",
  #      "dynamicgroupfilter"      => "dynamicGroupFilter",
  #      "dynamicmemberattribute"  => "dynamicMemberAttribute",
  #      "groupnameattribute"      => "groupNameAttribute",
  #      "groupmemberattribute"    => "groupMemberAttribute",
  #      "nestedgroups"            => "nestedGroups",
  #      "charset"                 => "charset",
  #      "anonymous_referrals"     => "anonymous_referrals",
  #      "sizelimit"               => "sizelimit",
  #      "timelimit"               => "timelimit",
  #      "network_timeout"         => "network_timeout",
  #    }
  #
  #  end
  #
  #  #translate the puppet property to the splunk counterpart or vice versa depending on the direction parameter Forward or Backward
  #  def translate_prop(prop, direction="f")
  #
  #    # get the dictionary hash
  #    dictionary = get_dictionary
  #
  #    # if the direction is b B for backward then return the hash key
  #    if direction == "b""
  #    dictionary.index("#{prop}")
  #    #else return the value
  #    else
  #      dictionary["#{prop}"]
  #    end
  #
  #  end
  #
  #  # compose a hash of our new keys and values... includes the translate step
  #  def get_property_hash
  #
  #    # init the hash
  #    property_hash = {}
  #
  #    # loop over the resource hash
  #    resource.to_hash.each do |key, value|
  #
  #      #translate the symbol to a usable string
  #      prop = translate_prop(key.id2name)
  #
  #      # is the value is an array .. convert it to a string joined by ;
  #      if value.class == Array
  #        value = value.join(';')
  #      end
  #
  #      # do nothing if the property is empty
  #      unless prop == nil
  #        property_hash["#{prop}"] = "#{value}"
  #      end
  #
  #    end
  #
  #    #and return the hash
  #    return property_hash
  #
  #  end

end