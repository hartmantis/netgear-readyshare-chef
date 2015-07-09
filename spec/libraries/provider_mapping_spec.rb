# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_mapping'

describe 'netgear-readyshare::provider_mapping' do
  let(:platform) { nil }
  let(:printer_app_provider) do
    plat = Chef::Platform.platforms[platform]
    plat && plat[:default][:netgear_readyshare_printer_app]
  end

  context 'Mac OS X' do
    let(:platform) { :mac_os_x }

    it 'uses the OS X printer app provider' do
      expected = Chef::Provider::NetgearReadysharePrinterApp::MacOsX
      expect(printer_app_provider).to eq(expected)
    end
  end

  context 'Windows' do
    let(:platform) { :windows }

    it 'has no printer app provider' do
      expect(printer_app_provider).to eq(nil)
    end
  end
end
