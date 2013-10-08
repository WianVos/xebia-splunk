module Puppet::Parser::Functions
  newfunction(:check_storedconfigs, :type => :rvalue ) do |arguments|

  stored_configs = false     
  stored_configs = Puppet.settings[:storeconfigs] if Puppet.settings[:storeconfigs].is_a? String
  
 end
end