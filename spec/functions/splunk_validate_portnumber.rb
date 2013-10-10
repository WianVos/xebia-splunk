require 'spec_helper'

describe 'validate_portnumber' do
	it { should run.with_params('foo').and_raise_error(Puppet::ParseError) }
	it { should run.with_params('80008').and_raise_error(Puppet::ParseError)}
	it { should run.with_params('8080')}

end
	
