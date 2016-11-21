require_relative '../spec_helper'

describe 'rundeck-server::install' do

  let(:platform) { 'centos' }
  let(:version) { '6.5' }
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: platform, version: version
    ).converge(described_recipe)
  end

  context 'with Centos' do
    it 'converges without error' do
      expect{ chef_run }.not_to raise_error
    end
  end

  context 'with Ubuntu' do
    let(:platform) { 'ubuntu' }
    let(:version) { '14.04' }

    it 'converges without error' do
      expect{ chef_run }.not_to raise_error
    end
  end
end
