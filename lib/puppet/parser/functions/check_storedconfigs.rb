module Puppet::Parser::Functions
  newfunction(:check_storedconfigs, :type => :rvalue ) do |arguments|

  stored_configs = false     
  stored_configs = Puppet.settings[:storeconfigs]
  return stored_configs
       
 end
end