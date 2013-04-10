#todo solve the license group issue

require 'pathname'
require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk.rb'))

Puppet::Type.type(:splunk_license).provide(:splunk, :parent => Puppet::Provider::Splunk ) do

  confine :osfamily => [:redhat, :ubuntu]

  commands :splunk => "splunk"

  # one day i'm gonna find out why the fuck this is not working .. but for now..
  def self.instances

    splunk_licenses = []
    options = {}

    get_licenses_hash.each do |name, values|
      options= {:name => "#{name}",
        :hash => "#{values["license_hash"]}",
        :ensure => :present }
      splunk_licenses << new(options)
    end
    splunk_licenses
  end

  

  def self.prefetch(resources)
    splunk_licenses = instances
    resources.keys.each do |name|
      if provider = splunk_licenses.find{ |splunk_license| splunk_license.name == name }
        resources[name].provider = provider
      end
    end
  end

  def create

    args = []

    install_file = get_install_file?

    args << "licenses"
    args << "\'#{install_file}\'"

    if install_file != nil
      splunk_exec("add", args, splunkd_running=true)

    else
      self.notice "installfile not set. Unable to install the license. Beter luck next time"
    end

  end

  def destroy

    args = []

    args << "licenses"
    args << "#{@property_hash[:hash]}"

    splunk_exec("remove", args, splunkd_running=true)

  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def get_install_file?
    "#{resource[:tmp_fs]}/#{resource[:name]}/#{File.basename(resource[:source])}"
  end

  def self.get_licenses_hash

    licenses = {}
    h = {}

    `splunk list licenses`.each_line do |line|

      if line == "\n"
        licenses["#{h['label']}"] =  h

        h = {}

      else
        attrib, value = line.to_s.gsub(/\n/,'').gsub(/\t/,'').split(':')
        h["#{attrib}"] = value unless  attrib == nil or value == nil
      end
    end
    return licenses
  end

end