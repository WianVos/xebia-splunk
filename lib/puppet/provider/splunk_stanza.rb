#!/usr/bin/ruby

require File.expand_path(File.join(File.dirname(__FILE__), '..','provider/lib/stanza.rb'))

class Puppet::Provider::Splunk_stanza < Puppet::Provider 
  
  
  
  confine :osfamily => [:redhat, :ubuntu]
  
  def initialize(value={})
      @dictionary = self.class.dictionary
      @resource_identifier = self.class.resource_identifier
      @config_file = self.class.config_file
      @stanza = Stanza.new(@config_file)
       
      super(value)
  
  
      @dictionary.each_key do | prop |
  
        #use instance eval to dynamicly add code to the class ..
        instance_eval %Q{
  
                   # add a method with the name #{prop}
                    def #{prop}
  
                      # get the property from the property hash
                      result = nil
                      if @property_hash.has_key?("#{prop}".to_sym)
                        result = @property_hash["#{prop}".to_sym]
                      end
  
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
                      @property_hash["#{prop}".to_sym] = value
                    end
                   }
  
      end
    end
  
    def self.instances
  
      instances_array = []
  
      get_all_resources.each do |name, properties|
  
        options = {:name => "#{name}",
          :ensure => :present
        }
        
        properties.each do |key, value|
          propname = dictionary.index("#{key}").to_sym
          option = { propname => value}
          options = options.merge!(option)
        end
        instances_array << new(options)
      end
  
      return instances_array
  
    end
  
    def exists?
      @property_hash[:ensure] == :present
    end
  
    def self.prefetch(resources)
      local_instances = instances
      resources.keys.each do |name|
        if provider = local_instances.find{ |x| x.name == name }
          resources[name].provider = provider
        end
      end
    end
  
    def create
      @property_hash[:ensure] = :present
  
      get_authorize_add_hash.each do |prop, value|
  
        @property_hash["#{prop}".downcase.to_sym] = value
  
      end
      
    end
  
    def destroy
      @property_hash[:ensure] = :absent
    end
  
    def get_authorize_add_hash
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
    def flush
      options = {}
        # if the property hash has ensure set to present then merge the property_hash into the correct part of the authorize_hash
        if @property_hash[:ensure] == :present
    
                  
          # loop over the property hash  
      
          @property_hash.each do |key, value|
                    #get the properties translated to splunk speak
                    propname = @dictionary["#{key}"]
                    option = { propname => value} unless propname.nil?
                    options = options.merge!(option) unless option.nil?
          end
            
          put_resource("#{resource[:name]}", options)
    
        else
          delete_resource("#{resource[:name]}") 
          
        end
    
        
      end
  def self.get_all_resources()
    
    
    stanza = Stanza.new(config_file)
    stanza.get_resources(resource_identifier)
    
  end
  
  def get_all_resources()
    @stanza.get_resources(@resource_identifier)
  end
  
  def put_resource(resource_name, options)
    @stanza.update_resource(resource_name, options)
  end
  
  def delete_resource(resource_name)
    @stanza.delete_resource(resource_name)
  end
  
  
  
end