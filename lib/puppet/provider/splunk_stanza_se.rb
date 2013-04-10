#!/usr/bin/ruby

require File.expand_path(File.join(File.dirname(__FILE__), '..','provider/lib/stanza.rb'))

class Puppet::Provider::Splunk_stanza_se < Puppet::Provider
  def initialize(value)
    super(value)

    @dictionary = self.class.dictionary
    @config_file = self.class.config_file
    @stanza = Stanza.new(@config_file)

    @dictionary.each_key do | prop |

      #use instance eval to dynamicly add code to the class ..
      instance_eval %Q{

                         # add a method with the name #{prop}
                          def #{prop}

                            # get the property from the stanza hash
                            result = nil
                            result = @stanza.get_element_property(resource[:name], @dictionary["#{prop}"])

                            # check if the result is not nil

                            unless result == nil
                              #when the result contains a ; it has to be presented to the type as array
                              if result.include?(';')
                                result = result.split(';')
                                end
                             return result

                            end

                            # and return the fruit of our labor
                            return result
                          end

                          # add setter method
                          def #{prop}=(value)

                            # add the value to the hash in the correct place
                            @stanza.set_element_property(resource[:name], @dictionary["#{prop}"], value)

                          end
                         }

    end

  end

  def create

    #stanza = Stanza.new(@config_file)

    @stanza.add_stanza_element("#{resource[:name]}", get_options_add_hash )

  end

  def exists?

    #stanza = Stanza.new(@config_file)

    @stanza.has_stanza_element?("#{resource[:name]}")

  end

  def destroy

    #    stanza = Stanza.new(@config_file)

    @stanza.delete_resource("#{resource[:name]}")
  end

  def get_options_add_hash
    # init the hash
    property_hash = {}

    # loop over the resource hash
    resource.to_hash.each do |key, value|

      #translate the symbol to a usable string
      prop = @dictionary["#{key}"]

      # is the value is an array .. convert it to a string joined by ;
      if value.class == Array
        value = value.join(';')
      end

      # do nothing if the property is empty
      unless prop == nil
        property_hash["#{prop}"] = "#{value}"
      end

    end

    #and return the hash
    return property_hash

  end

end