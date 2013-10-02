class Stanza
  # this class is ment to be used with te meriad of splunk config files

  attr_accessor :Stanza_hash
  def initialize(filename)
    @filename = filename
    @Stanza_hash = {}
    get_stanza
  end

  def get_stanza()
    # check if the file exists .. and if not return a somewhat empty string

    if File.exists?("#{@filename}")
      file = File.open("#{@filename}").each_line.reject{|x| x.strip == "" or x.include?('#') }.join
    else
      file = ""
    end
    file.each_line do |line|
      if line.include? '['
        @hash_name = line.delete('[]').strip
        @Stanza_hash["#{@hash_name}"] = Hash.new
      else
        attribute, value = line.strip.split('=')
        value = "none" if value == nil
        @Stanza_hash["#{@hash_name}"]["#{attribute.strip}"] = "#{value.strip}"
      end
    end
  end

  def write_stanza()

    outfile = File.open("#{@filename}" , 'w')

    @output_string = "#edited by puppet\n#don't even think about editing this by hand!! \n"

    @Stanza_hash.sort.each do | key, values |

      # the first clause is in there because of the capability stanza notation found in authorize.conf
      if key.include? 'capability::'

        @output_string << "[#{key}]\n"

      else

        @output_string << "\n[#{key}]\n"

        values.each do |attribute, value|
          @output_string << " #{attribute}\t= #{value}\n"
        end

      end
    end
    outfile.write @output_string
    outfile.close
  end

  def update_resource(resource_name, options={})

    get_stanza
    @Stanza_hash["#{resource_name}"] = Hash.new unless @Stanza_hash.has_key? resource_name
    @Stanza_hash["#{resource_name}"] = options
    write_stanza

  end

  def delete_resource(resource_name)

    get_stanza
    if @Stanza_hash.has_key? resource_name
      @Stanza_hash.delete resource_name
    end
    write_stanza
  end

  def get_resources(identifier=nil)

    get_stanza

    @Stanza_hash.select {|k, v| k =~ /#{identifier}/ }

  end

  def stanza_element(identifier)

    get_stanza

    @Stanza_hash.select {|k, v| k =~ /#{identifier}/ }

  end

  def has_stanza_element?(identifier)

    get_stanza

    @Stanza_hash.has_key? identifier

  end

  def get_element_property(identifier, property)
    result = nil
    get_stanza
    if @Stanza_hash.has_key?("#{identifier}")
      if @Stanza_hash["#{identifier}"].has_key? property
        result =  @Stanza_hash["#{identifier}"]["#{property}"]
      end
    end

    return result
  end

  def set_element_property(identifier, property, value)
    get_stanza
    @Stanza_hash["#{identifier}"] = Hash.new unless @Stanza_hash.has_key? identifier
    @Stanza_hash["#{identifier}"] = @Stanza_hash["#{identifier}"].merge!({"#{property}" => "#{value}"}) 
    write_stanza
  end

  def delete_element_property(identifier, property)
    get_stanza
    if @Stanza_hash.has_key?("#{identifier}")
      if @Stanza_hash["#{identifier}"].has_key? property
        @Stanza_hash["#{identifier}"] = @Stanza_hash["#{identifier}"].delete property
      end
    end
    write_stanza
  end

  def add_stanza_element(identifier, options=nil)

    get_stanza
    @Stanza_hash["#{identifier}"] = Hash.new unless @Stanza_hash.has_key? identifier
    @Stanza_hash["#{identifier}"] = options unless options.nil?
    write_stanza

  end

end