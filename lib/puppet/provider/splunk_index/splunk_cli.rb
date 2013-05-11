require File.expand_path(File.join(File.dirname(__FILE__), '..','splunk.rb'))
  
Puppet::Type.type(:splunk_index).provide(:splunk, :parent => Puppet::Provider::Splunk ) do
  
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
   splunk_resource_exists?(name="#{resource[:indexname]}")
  end
  
  def create
    
    args = [] 
     
    args << "index"
    args << "#{resource[:indexname]}"
    args << "-coldPath #{resource[:coldpath]}" unless resource[:coldpath].nil?
    args << "-homePath #{resource[:homepath]}" unless resource[:homepath].nil?
    args << "-thawedPath #{resource[:thawedpath]}" unless resource[:thawedpath].nil?
    
    splunk_exec("add", args)
 
    
  end
  
  
  def destroy
    args = []
    args << "index"
    args << "#{resource[:indexname]}"
    
    splunk_exec("remove", args)
    
  end
  
  def coldpath  
      splunk_get_parameter?(name="#{resource[:indexname]}", parameter="coldPath_expanded")
  end
  
  def homepath
       splunk_get_parameter?(name="#{resource[:indexname]}", parameter="homePath_expanded")
  end
  
  def thawedpath
       splunk_get_parameter?(name="#{resource[:indexname]}", parameter="thawedPath_expanded")
      
  end

  def coldpath=(value)
     self.debug "coldPath needs a change"
     @property_flush[:index_move_cold] = :true
       
  end
  
  def homepath=(value)
    p  
    self.debug "coldPath needs a change"
    @property_flush[:index_move_home] = :true
  end
  
  def thawedpath=(value)
    self.debug "coldPath needs a change"
    @property_flush[:index_move_thawed] = :true
  end
  
  def flush
        if resource[:forceindexpath] == :true
         
          if @property_flush[:index_move_home] == :true or @property_flush[:index_move_cold] == :true or @property_flush[:index_move_thawed] == :true 
            destroy()
            create()
          end
          
        else
          
          self.debug "unable to migrate data paths and forceindexpath is set to false"
          
        end
   end
     
end