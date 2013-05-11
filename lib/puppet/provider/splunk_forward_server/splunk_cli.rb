require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk.rb'))
  
Puppet::Type.type(:splunk_forward_server).provide(:splunk, :parent => Puppet::Provider::Splunk ) do
  
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
    
        args << "forward-server "
        args << "--no-prompt"
    
        exec_args = args.join " "
    
        command = "splunk list  #{exec_args}"
        self.debug command
    
        result = `#{command}`
    
        exists = true if result =~ /#{resource[:servername]}/ 
         
  end
  
  def create
    
    args = [] 
    
    args << "forward-server"
    args << "#{resource[:servername]}:#{resource[:port]}"  
    
    splunk_exec(sub_command="add", passed_args=args, splunkd_running="true")
    
  end
  
  
  def destroy
    
  
            args = []
            
            args << "forward-server"
            args << "#{resource[:servername]}:#{resource[:port]}" 
              
            splunk_exec(sub_command="remove", passed_args=args, splunkd_running="true")
         
  end
  
  
  def port
            args = []
        
            exec_args = []
        
            exists = 0
        
            args << "forward-server"
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
    create
  end
  
end