require File.expand_path('../../util/splunk_ini_file', __FILE__)
require 'pathname'

class Puppet::Provider::Splunk_ini_file  < Puppet::Provider

  
  
  def initialize(value={})

    super(value)

    #hashes, array's and strings need to be dealt with separetly due the the manor in wich simplexml presents them to the system.

    # the simple string properties for the ci
    @properties = self.class.properties
    # unless properties is set to nil add the following getter and setter methods to the namespace for each property
    unless @properties == nil

      @properties.each do | prop |
        downcase_prop = prop.downcase
        #use instance eval to dynamicly add code to the class ..
        instance_eval %Q{

          # add a method with the name #{prop}
          def #{downcase_prop}

           # get the property from the property hash

           result = nil

           if @property_hash.has_key?("#{prop}")
             result = @property_hash["#{prop}"]
           end
          
          # and return the fruit of our labor
          return result
         end

         # add setter method
         def #{downcase_prop}=(value)

         # add the value to the hash in the correct place
          @property_hash["#{prop}"] = value
         end
        }
      end
    end
  end

  def exists?
    get_properties_hash
    #    ini_file.has_section?(resource[:name])
    @property_hash["exists"] == true
  end

  
  def create

    # we have three catagories of properties that need to be added to the properties hash
    # loop over the regular properties and add the values to the property hash ready for flushing
    if @properties != nil

      @properties.each do |p|

        # fill the property hash with the values from the resource hash
        # it is important to note that the keys are in the resource hash in symbol form
        # but we need them in their string form
        @property_hash["#{p}"] = resource["#{p}".downcase.to_sym] unless resource["#{p}".downcase.to_sym] == nil

      end
    end
  end

  
  def destroy
    # hoeray for flushing .. the only thing we need to do here is set ensure to absent
    @property_hash["ensure"] = "absent"
  end

  def flush

    # remove the confilicting fields from the hash and get the values to seperate variables we can use the determine the flow of the flush
    ensure_prop = @property_hash.delete('ensure')
    exists = @property_hash.delete('exists')

    #check if the ensure param is set to present
    if ensure_prop == "present"

      # push the property hash to the splunk config

      @property_hash.each {|k, v| ini_file.set_value(resource[:name], "#{k}" , resource["#{k}".downcase.to_sym] )unless resource["#{k}".downcase.to_sym] == nil }

    else

      # delete the resource if ensure is set to absent

      ini_file.remove_section(resource[:name])

    end
    
    ini_file.save
    @ini_file = nil

  end

  
  def file_path

    default_file = "#{self.class.dir_prefix}/#{resource[:app]}/default/#{self.class.file_name}"
    local_file = "#{self.class.dir_prefix}/#{resource[:app]}/local/#{self.class.file_name}"

    local_dir = Pathname.new(local_file).dirname

    mkdir("#{local_dir}") unless File.directory?(local_dir)

    unless File.file?(local_file)
      touch('#{local_file}') unless File.file?(default_file)
      cp('-p',"#{default_file}", "#{local_file}") if File.file?(default_file)
      chmod('755',"#{local_file}")
    end

    return local_file

  end

  def separator
    '='
  end

  

  def get_properties_hash
    # initialize the global property_hash
    @property_hash = {}

    # initialize the ensure property with the present value
    # if the destroy method gets called it will change to absent

    # setup a new connection to the deployit server
    c = ini_file.get_settings(resource[:name]) unless ini_file.get_settings(resource[:name]) == nil

    #check if the resource exists
    if c != nil

      # if it does exist
      # get the ci's property's into a hash
      @property_hash = c
      @property_hash["ensure"] = "present"
      @property_hash["exists"] = true

    else

      # if it doesn't exist set the exists field to false
      @property_hash["exists"] = false
      @property_hash["ensure"] = "present"

    end
  end

  

  private

  def ini_file
    @ini_file ||= Puppet::Util::Splunk_IniFile.new(file_path, separator)
  end

end
