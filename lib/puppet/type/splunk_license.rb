require 'pathname'

Puppet::Type.newtype(:splunk_license) do

  desc 'custom type to install apps to splunk'

  # ensurable
  ensurable do
    desc "splunk license resource state"

    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end
  end

  newparam(:name, :namevar => true) do
    desc 'name of this license. This should correspond with the label found in the license file'
  end

  # general properties

  newparam(:hash) do
    desc 'license hash.. do not use'
  end

  newparam(:source) do
    desc 'license file to use for app. Must be splunk license file'
  end

  newparam(:tmp_fs) do
    defaultto "/var/tmp"
    desc 'temporary filesystem to use for app.'
  end

  # autorequire
  autorequire(:package) do
    'splunk'
  end

  autorequire(:file) do
    @license_source
    @tmp_fs
    'splunk etc link'
    'splunk sbin link'
    'splunk var link'

  end

  autorequire(:splunk_login) do
    'admin'
  end

  def initialize(*args)
    super

    self[:notify] = [ "Service[splunk]","Service[splunkd]",].select { |ref| catalog.resource(ref) } unless catalog.nil?

    if args[0].to_hash[:ensure] != "absent" and args[0].to_hash[:source] != nil
      tmp_fs = get_tmp_fs(args[0].to_hash[:tmp_fs])

      install_file  = get_app_file(source="#{args[0].to_hash[:source]}",destination_base="#{tmp_fs}")

      args[0][:install_file] = install_file
    end

  end

  def get_app_file(source,destination_base="/var/tmp")

    # Add a file resource that will get the file
    #todo: make sure where not adding an already existing resource to the catalog.

    filename = File.basename(source)

    params = { :name => "#{destination_base}/#{filename}",
      :source => source,
      :ensure => "present",
      :owner => "root",
      :mode => 0700
    }

    sourcefile = Puppet::Type.type(:file).new(params)
    catalog = Puppet::Resource::Catalog.new
    catalog.add_resource sourcefile
    catalog.apply

    @package_source =  "#{destination_base}/#{filename}"

    return @package_source

  end

  def get_tmp_fs(tmp_fs)
    # make sure the tmp fs is here

    if  tmp_fs == nil
      tmp_fs = "/var/tmp/#{name}"
    else
      tmp_fs = "#{tmp_fs}/#{name}"
    end

    params = {    :name => "#{tmp_fs}",
      :ensure => "directory",
      :owner => "root",
      :mode => 0700
    }
    temporary_directory = Puppet::Type.type(:file).new(params)
    catalog = Puppet::Resource::Catalog.new
    catalog.add_resource temporary_directory
    catalog.apply

    @tmp_fs = tmp_fs

    return tmp_fs

  end

end