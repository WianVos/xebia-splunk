require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk.rb'))
  
Puppet::Type.type(:splunk_search_server).provide(:splunk, :parent => Puppet::Provider::Splunk ) do
  
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
    
        args << "search-server "
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
 
    command = "splunk add search-server #{resource[:servername]}:#{resource[:port]} -remoteUsername #{resource[:remoteuser]} -remotePassword #{resource[:remotepassword]}  "
    
    self.debug command
     
    result = `#{command}`
    
    self.fail result unless $?.exitstatus == 0 or $?.exitstatus == 22 or $?.exitstatus == 24
    
  end
  
  
  def destroy
    distsearch_file = "/etc/splunk/local/distsearch.conf"
    
    if File.exists?("#{distsearch_file}")
      file = File.open("#{distsearch_file}", "r").each_line.select{|x| x.strip =~ /servers/ }.join
    else
      self.fail "unable to find #{distsearch_file}"
    end
    
    file.each do |x|
      attrib, seperator, value = x.split
        value.split(',').each do |y|
          
          hostname, portnumber = y.split ':'
          if hostname == resource[:servername]
            args = []
            
              args << "search-server"
              args << "#{resource[:servername]}:#{portnumber}" 
              
            splunk_exec(sub_command="remove", passed_args=args, splunkd_running="true")
          end
        end
    end
  end
  
  
  def port
            args = []
        
            exec_args = []
        
            exists = 0
        
            args << "search-server "
            args << "--no-prompt"
            args << "--accept-license"
        
            exec_args = args.join " "
        
            command = "splunk list  #{exec_args}"
            self.debug command
        
            result = `#{command}`
        
            if result =~ /#{resource[:servername]}[:]#{resource[:port]}/ 
              exists = resource[:port]
            end
            
            return exists
  end
  
  def port=(value)
    destroy
    # create
  end
  
end