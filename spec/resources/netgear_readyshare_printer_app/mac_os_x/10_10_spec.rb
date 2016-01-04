require_relative '../../../spec_helper'

describe 'resource_netgear_readyshare_printer_app::mac_os_x::10_10' do
  let(:version) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'netgear_readyshare_printer_app',
      platform: 'mac_os_x',
      version: '10.10'
    )
  end
  let(:converge) do
    runner.converge("netgear_readyshare_printer_app_test::#{action}")
  end

  context 'the default action (:install)' do
    let(:action) { :default }
    let(:installed?) { nil }

    before(:each) do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with(
        '/Applications/NETGEAR/NETGEAR USB Control Center.app'
      ).and_return(installed?)
    end

    context 'not already installed' do
      let(:installed?) { false }
      cached(:chef_run) { converge }

      it 'downloads the app .zip file' do
        expect(chef_run).to create_remote_file(
          "#{Chef::Config[:file_cache_path]}/" \
          'NETGEAR_USB_Control_Center_Installer_V2.22.zip'
        ).with(source: 'http://www.downloads.netgear.com/files/GDC/R6300/' \
                       'NETGEAR_USB_Control_Center_Installer_V2.22.zip')
      end

      it 'extracts the .dmg from the .zip file' do
        expect(chef_run).to run_execute('Unzip Netgear app').with(
          command: "unzip -p #{Chef::Config[:file_cache_path]}/" \
                   'NETGEAR_USB_Control_Center_Installer_V2.22.zip > ' \
                   "#{Chef::Config[:file_cache_path]}/netgear.dmg"
        )
      end

      it 'extracts the installer from the .dmg' do
        expect(chef_run).to install_dmg_package(
          'NETGEAR USB Control Center Installer'
        ).with(source: "file://#{Chef::Config[:file_cache_path]}/netgear.dmg",
               destination: Chef::Config[:file_cache_path])
      end

      it 'runs the installer' do
        expect(chef_run).to run_execute('Run Netgear installer').with(
          command: "#{Chef::Config[:file_cache_path]}/NETGEAR\\ USB\\ " \
                   'Control\\ Center\\ Installer.app/Contents/MacOS/' \
                   'NETGEAR\\ USB\\ Control\\ Center\\ Installer'
        )
      end
    end

    context 'already installed' do
      let(:installed?) { true }
      cached(:chef_run) { converge }

      it 'does not download the app .zip file' do
        expect(chef_run).to_not create_remote_file(
          "#{Chef::Config[:file_cache_path]}/" \
          'NETGEAR_USB_Control_Center_Installer_V2.22.zip'
        )
      end

      it 'does not extract the .dmg from the .zip file' do
        expect(chef_run).to_not run_execute('Unzip Netgear app')
      end

      it 'does not extract the installer from the .dmg' do
        expect(chef_run).to_not install_dmg_package(
          'NETGEAR USB Control Center Installer'
        )
      end

      it 'does not run the installer' do
        expect(chef_run).to_not run_execute('Run Netgear installer')
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'deletes the main app dir' do
      d = '/Applications/NETGEAR/NETGEAR USB Control Center.app'
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end
  end
end
