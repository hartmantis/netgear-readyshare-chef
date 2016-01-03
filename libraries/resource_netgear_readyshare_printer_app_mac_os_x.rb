# Encoding: UTF-8
#
# Cookbook Name:: netgear-readyshare
# Library:: resource_netgear_readyshare_printer_app_mac_os_x
#
# Copyright 2015-2016 Jonathan Hartman
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
require_relative 'resource_netgear_readyshare_printer_app'

class Chef
  class Resource
    # An implementation of the `netgear_readyshare_printer_app` resource for
    # OS X.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class NetgearReadysharePrinterAppMacOsX < NetgearReadysharePrinterApp
      PATH ||= '/Applications/NETGEAR/NETGEAR USB Control Center.app'
      URL ||= 'http://www.downloads.netgear.com/files/GDC/R6300/' \
              'NETGEAR_USB_Control_Center_Installer_V2.22.zip'

      provides :netgear_readyshare_printer_app, platform_family: 'mac_os_x'

      #
      # (see NetgearReadysharePrinterApp#install!)
      #
      action :install do
        download_path = ::File.join(Chef::Config[:file_cache_path],
                                    ::File.basename(URL))
        dmg_path = ::File.join(Chef::Config[:file_cache_path], 'netgear.dmg')
        installer_path = ::File.join(
          Chef::Config[:file_cache_path],
          'NETGEAR USB Control Center Installer.app/Contents/MacOS',
          'NETGEAR USB Control Center Installer'
        )
        remote_file download_path do
          source URL
          only_if { !::File.exist?(PATH) }
        end
        execute 'Unzip Netgear app' do
          command "unzip -p #{download_path} > #{dmg_path}"
          only_if { !::File.exist?(PATH) }
        end
        dmg_package 'NETGEAR USB Control Center Installer' do
          source "file://#{dmg_path}"
          destination Chef::Config[:file_cache_path]
          only_if { !::File.exist?(PATH) }
        end
        execute 'Run Netgear installer' do
          command installer_path.gsub(' ', '\\ ')
          only_if { !::File.exist?(PATH) }
        end
      end

      #
      # Clean up ReadyShare's install directory.
      #
      action :remove do
        directory PATH do
          recursive true
          action :delete
        end
      end
    end
  end
end
