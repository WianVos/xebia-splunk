require 'spec_helper'

describe 'splunk' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      describe "splunk class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should include_class('splunk::params') }
        it { should include_class('splunk::validation') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'splunk class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
  context 'general server config testing' do
    let(:params) {{:role => 'indexer'}}

    describe 'splunk basic configuration' do
      let(:facts) {{ :fqdn => 'localserver.localdomain',
                     :osfamily => 'RedHat' }}
      let(:params){{
        :splk_indexfs => '/var/splunk/data',
        :splk_webport => '8001',
        :splk_adminport => '9001',
        :splk_minfreemb => '600'
        }}

      it { should create_splunk_config('default')\
        .with_hostname('localserver.localdomain')\
        .with_webport('8001')\
        .with_splunkport('9001')\
        .with_datastore('/var/splunk/data')\
        .with_minfreemb('600')}

     it { should create_file('splunk data filesystem').with_path('/var/splunk/data')}
    end
  end

  context 'indexer stream testing' do
    
    let(:params) {{:role => 'indexer'}}
    let(:facts) {{ :osfamily => 'RedHat'}}

    describe 'splunk class with splk_indexer_indexes filled' do
      let(:params) {{
        :splk_indexer_indexes => {'index1' => {'ensure' => 'present' }, 
                                  'index2' => {'ensure' => 'absent'} }, 
        }}
      it { should create_splunk_index('index1').with_ensure('present') } 
      it { should create_splunk_index('index2').with_ensure('absent') }
              
    end

    describe 'splunk class with splk_tcpports filled' do
     let(:params) {{
        :splk_indexer_tcpports  => {'tcp://192.168.0.3:10007' => {'ensure' => 'present', 'index' => 'index1', 'source' => 'testsource', 'sourcetype' => 'testtype' }, 
                                    'tcp://192.168.0.4:10008' => {'ensure' => 'absent', 'index' => 'index2', 'source' => 'testsource', 'sourcetype' => 'testtype' }},
        
        }} 
      it { should create_splunk_tcp_port('tcp://192.168.0.3:10007').with_ensure('present').with_index('index1').with_source('testsource').with_sourcetype('testtype') } 
      it { should create_splunk_tcp_port('tcp://192.168.0.4:10008').with_ensure('absent')}         
    end

    describe 'splunk class with splk_udpports filled' do
     let(:params) {{
        :splk_indexer_udpports  => {'udp://192.168.0.3:10007' => {'ensure' => 'present', 'index' => 'index1', 'source' => 'testsource', 'sourcetype' => 'testtype' }, 
                                    'udp://192.168.0.4:10008' => {'ensure' => 'absent', 'index' => 'index2', 'source' => 'testsource', 'sourcetype' => 'testtype' }},
        }} 
      it { should create_splunk_udp_port('udp://192.168.0.3:10007').with_ensure('present').with_index('index1').with_source('testsource').with_sourcetype('testtype') } 
      it { should create_splunk_udp_port('udp://192.168.0.4:10008').with_ensure('absent')}         
    end

    describe 'splunk class with splk_splunktcp_ports filled' do
      let(:params) {{
        :splk_indexer_splunktcpports => {'splunktcp://192.168.0.3:10007' => {'ensure' => 'present', 'enables2sheartbeat' => 'true'}, 
                                  'splunktcp://192.168.0.4:10008' => {'ensure' => 'absent'}},
        }} 
        it { should create_splunk_splunktcp_port('splunktcp://192.168.0.3:10007').with_ensure('present').with_enables2sheartbeat('true')} 
        it { should create_splunk_splunktcp_port('splunktcp://192.168.0.4:10008').with_ensure('absent')}        
    end
    # test validation
    describe 'splunk class with splk_indexer_tcpports not a hash' do
      let(:params) {{
        :splk_indexer_tcpports => 'foobar',
        }}
        it { expect { should }.to raise_error(Puppet::Error,/looks to be a String/) }
    end

    describe 'splunk class with splk_indexer_splunktcpports not a hash' do
      let(:params) {{
        :splk_indexer_splunktcpports => 'foobar',
        }}
        it { expect { should }.to raise_error(Puppet::Error,/looks to be a String/) }
    end

    describe 'splunk class with splk_indexer_udpports not a hash' do
      let(:params) {{
        :splk_indexer_tcpports => 'foobar',
        }}
        it { expect { should }.to raise_error(Puppet::Error,/looks to be a String/) }
    end

    describe 'splunk class with splk_indexer_indexes not a hash' do
      let(:params) {{
        :splk_indexer_indexes => 'foobar',
        }}
        it { expect { should }.to raise_error(Puppet::Error,/looks to be a String/) }
    end
  end


  context 'searchhead stream testing' do
    let (:params) {{:role => 'searchhead'}}
    let (:facts) {{ :osfamily => 'RedHat' }}

    describe 'splunk class with splk_sh_roles filled' do
      let(:params) {{
      :splk_sh_roles => {'role1' => {'ensure' => 'present', 'importroles' => ['role2','role3'], 'srchtimewin' => '60' }, 
                         'role2' => {'ensure' => 'present', 'srchtimewin' => '60' },
                         'role3' => {'ensure' => 'absent'}}
      }}
      it { should create_splunk_role('role1').with_ensure('present').with_importroles(['role2','role3']).with_srchtimewin('60')}
      it { should create_splunk_role('role2').with_ensure('present').with_srchtimewin('60')}
      it { should create_splunk_role('role3').with_ensure('absent')}
    end

    describe 'splunk class with splk_sh_authenticationserver filled' do
      let(:params) {{
        :splk_sh_authenticationserver => {'server1' => { 'ensure' => 'present', 'binddn' => 'tst123', 'binddnpassword' => 'test123' }}
        }}
        it { should create_splunk_authentication_server('server1').with_ensure('present').with_binddn('tst123').with_binddnpassword('test123')}
    end

    # validation testing
    describe 'splunk class with splk_sh_roles not a hash' do
      let(:params) {{
        :splk_sh_roles => 'foobar',
        }}
        it { expect { should }.to raise_error(Puppet::Error,/looks to be a String/) }
    end
    describe 'splunk class with splk_sh_authenticationserver not a hash' do
      let(:params) {{
        :splk_sh_authenticationserver => 'foobar',
        }}
        it { expect { should }.to raise_error(Puppet::Error,/looks to be a String/) }
    end
  end
end


    


