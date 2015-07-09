# Encoding: UTF-8

require_relative '../spec_helper'

describe 'netgear-readyshare::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs the ReadySHARE printer app' do
    expect(chef_run).to install_netgear_readyshare_printer_app('default')
  end
end
