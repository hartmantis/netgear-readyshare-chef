# Encoding: UTF-8
#
# Cookbook Name:: netgear-readyshare
# Library:: provider_netgear_readyshare_printer_app_mac_os_x
#
# Copyright 2015 Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'net/http'
require 'chef/provider/lwrp_base'
require_relative 'provider_netgear_readyshare_printer_app'

class Chef
  class Provider
    class NetgearReadysharePrinterApp < Provider::LWRPBase
      # An provider for Netgear USB Control Center for OS X.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < NetgearReadysharePrinterApp
        PATH ||= '/Applications/NETGEAR/NETGEAR USB Control Center.app'
        URL ||= 'http://www.downloads.netgear.com/files/GDC/R6300/' \
                'NETGEAR_USB_Control_Center_Installer_V2.22.zip'

        private

        #
        # (see NetgearReadysharePrinterApp#install!)
        #
        def install!
          download_package
          extract_zip
          extract_dmg
          run_installer
        end

        #
        # (see NetgearReadysharePrinterApp#remove!)
        #
        def remove!
          directory PATH do
            recursive true
            action :delete
          end
        end

        #
        # Use an execute resource to run the installer script.
        #
        def run_installer
          cmd = ::File.join(Chef::Config[:file_cache_path],
                            'NETGEAR USB Control Center Installer.app',
                            'Contents/MacOS',
                            'NETGEAR USB Control Center Installer')
          execute 'Run Netgear installer' do
            command cmd.gsub(' ', '\ ')
            action :run
            only_if { !::File.exist?(PATH) }
          end
        end

        #
        # Use a dmg_package resource to extract the Installer script from the
        # .dmg file that was inside the .zip file.
        #
        def extract_dmg
          s = "file://#{dmg_path}"
          dmg_package 'NETGEAR USB Control Center Installer' do
            source s
            destination Chef::Config[:file_cache_path]
            action :install
            only_if { !::File.exist?(PATH) }
          end
        end

        #
        # Use an execute resource to unzip the package into /Applications/
        #
        def extract_zip
          zip = download_path
          dmg = dmg_path
          execute 'Unzip Netgear app' do
            command "unzip -p #{zip} > #{dmg}"
            action :run
            only_if { !::File.exist?(PATH) }
          end
        end

        #
        # Use a remote_file resource to download the package.
        #
        def download_package
          remote_file download_path do
            source URL
            action :create
            only_if { !::File.exist?(PATH) }
          end
        end

        #
        # Build a path for the .dmg file that gets extracted from the
        # downloaded .zip.
        #
        # @return [String] a path on the local filesystem
        #
        def dmg_path
          ::File.join(Chef::Config[:file_cache_path], 'netgear.dmg')
        end

        #
        # Construct a local cache path to download the package to.
        #
        # @return [String] a path on the local filesystem
        #
        def download_path
          ::File.join(Chef::Config[:file_cache_path], ::File.basename(URL))
        end
      end
    end
  end
end
