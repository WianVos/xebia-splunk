require 'rubygems'
require 'rake'
require 'puppet-lint/tasks/puppet-lint'
require 'mechanize'
require 'logger'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# paths not to include in any check lint or syntax
exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

## puppet lint configuration

PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = exclude_paths


# Puppet syntax configuration
PuppetSyntax.exclude_paths = exclude_paths


desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :lint,
  :spec
]

task :get_source do
	# read the configfile in ./config
	config = nil
	config_file = "./config/source_files.yaml"
        config = YAML.load_file(config_file) unless config_file == nil
	
	# if the configfile was found and contained sensible information we will loop over the files and download them into the designated paths
	config.keys.each {|k|
	 
	 # report what where doing
	 puts "start downloading #{File.basename(k)}"  
	 
	 # get the authentication parameters if any
	 username = nil
	 password = nil
	 username = config[k]['username'] unless config[k]['username'] == nil
	 password = config[k]['password'] unless config[k]['password'] == nil
	
	 # get the download url
	 download_url = config[k]['download_url']


	 # setup the mechanize engine
         agent = Mechanize.new
         agent.user_agent_alias = 'Mac Safari'
         agent.pluggable_parser.default = Mechanize::Download
	 
	 # setup a log file per downloaded file in /tmp
         agent.log = Logger.new "/tmp/#{File.basename(k)}-download.log"

	 # add authentication for the download url if the username parameter is filled
         agent.add_auth(download_url, username, password) unless username == nil

	 # download the file and save it to the correct path
         agent.get("#{download_url}").save("#{k}")
		
	 # and again report what where doing 
	 puts "finished downloading #{File.basename(k)}"  
	 } unless config == nil
end


