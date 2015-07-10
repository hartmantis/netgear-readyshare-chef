# Encoding: UTF-8

include_recipe 'netgear-readyshare'

netgear_readyshare_printer_app 'default' do
  action :remove
end
