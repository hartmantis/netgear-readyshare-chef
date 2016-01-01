# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_netgear_readyshare_printer_' \
                 'app_mac_os_x'

describe Chef::Provider::NetgearReadysharePrinterApp::MacOsX do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) do
    Chef::Resource::NetgearReadysharePrinterApp.new(name, run_context)
  end
  let(:provider) { described_class.new(new_resource, run_context) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = '/Applications/NETGEAR/NETGEAR USB Control Center.app'
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe 'URL' do
    it 'returns a download URL' do
      expected = 'http://www.downloads.netgear.com/files/GDC/R6300/' \
                 'NETGEAR_USB_Control_Center_Installer_V2.22.zip'
      expect(described_class::URL).to eq(expected)
    end
  end

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.10' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    it 'downloads and installs the package' do
      p = provider
      expect(p).to receive(:download_package)
      expect(p).to receive(:extract_zip)
      expect(p).to receive(:extract_dmg)
      expect(p).to receive(:run_installer)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'removes the directory' do
      p = provider
      expect(p).to receive(:directory).with(described_class::PATH).and_yield
      expect(p).to receive(:recursive).with(true)
      expect(p).to receive(:action).with(:delete)
      p.send(:remove!)
    end
  end

  describe '#run_installer' do
    it 'uses an execute resource to run the installer' do
      p = provider
      expect(p).to receive(:execute).with('Run Netgear installer').and_yield
      expect(p).to receive(:command).with(
        "#{Chef::Config[:file_cache_path]}/" \
          'NETGEAR\ USB\ Control\ Center\ Installer.app/Contents/MacOS/' \
          'NETGEAR\ USB\ Control\ Center\ Installer'
      )
      expect(p).to receive(:action).with(:run)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
      p.send(:run_installer)
    end
  end

  describe '#extract_dmg' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:dmg_path)
        .and_return('/tmp/netgear.dmg')
    end

    it 'uses a dmg_package resource to extract the installer' do
      p = provider
      expect(p).to receive(:dmg_package)
        .with('NETGEAR USB Control Center Installer').and_yield
      expect(p).to receive(:source).with('file:///tmp/netgear.dmg')
      expect(p).to receive(:destination).with(Chef::Config[:file_cache_path])
      expect(p).to receive(:action).with(:install)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
      p.send(:extract_dmg)
    end
  end

  describe '#extract_zip' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/netgear.zip')
      allow_any_instance_of(described_class).to receive(:dmg_path)
        .and_return('/tmp/netgear.dmg')
    end

    it 'uses an execute to unzip the installer .dmg' do
      p = provider
      expect(p).to receive(:execute).with('Unzip Netgear app').and_yield
      expect(p).to receive(:command)
        .with('unzip -p /tmp/netgear.zip > /tmp/netgear.dmg')
      expect(p).to receive(:action).with(:run)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
      p.send(:extract_zip)
    end
  end

  describe '#download_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/netgear.zip')
    end

    it 'uses a remote_file to download the package' do
      p = provider
      expect(p).to receive(:remote_file).with('/tmp/netgear.zip').and_yield
      expect(p).to receive(:source).with(described_class::URL)
      expect(p).to receive(:action).with(:create)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
      p.send(:download_package)
    end
  end

  describe '#dmg_path' do
    it 'returns a path in the Chef cache dir' do
      expect(provider.send(:dmg_path)).to eq(
        "#{Chef::Config[:file_cache_path]}/netgear.dmg"
      )
    end
  end

  describe '#download_path' do
    it 'returns a path in the Chef cache dir' do
      expect(provider.send(:download_path)).to eq(
        "#{Chef::Config[:file_cache_path]}/" \
          'NETGEAR_USB_Control_Center_Installer_V2.22.zip'
      )
    end
  end
end
