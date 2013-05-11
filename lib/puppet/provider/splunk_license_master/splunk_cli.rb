require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk.rb'))

Puppet::Type.type(:splunk_license_master).provide(:splunk, :parent => Puppet::Provider::Splunk ) do

  confine :osfamily => [:redhat, :ubuntu]

  commands :splunk => "splunk"

  #initialize
  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  #parameter getters and setters

  # this type is ensurable
  def exists?
    args = []

    exec_args = []

    exists = false

    args << "licenser-localslave "
    args << "--no-prompt"
    args << "--accept-license"

    exec_args = args.join " "

    command = "splunk list  #{exec_args}"
    self.debug command

    result = `#{command}`

    if result =~ /#{resource[:servername]}/
      exists = true
    end

    return exists
  end

  def create

    args = []

    exec_args = []

    command = "splunk edit licenser-localslave -master_uri https://#{resource[:servername]}:#{resource[:port]} "

    self.debug command

    result = `#{command}`

    self.fail result unless $?.exitstatus == 0
    
  end

  def destroy
    args = []

    exec_args = []

    command = "splunk edit licenser-localslave -master_uri self "

    self.debug command

    result = `#{command}`

    self.fail result unless $?.exitstatus == 0
  end

end