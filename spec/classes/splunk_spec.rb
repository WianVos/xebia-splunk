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
  end
end


