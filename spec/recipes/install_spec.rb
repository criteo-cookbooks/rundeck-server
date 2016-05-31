require_relative '../spec_helper'

describe 'rundeck-server::install' do

  let(:platform) { 'centos' }
  let(:version) { '6.5' }
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
      node.set['rundeck_server']['packages']['rpm']['rundeck'] = '2.6.4-1.15.GA'
      node.set['rundeck_server']['packages']['rpm']['rundeck-config'] = '2.6.4-1.15.GA'
      node.set['rundeck_server']['packages']['deb']['rundeck'] = '2.6.4'
    end.converge(described_recipe)
  end

  context 'with Centos' do
    it 'create yum repo' do
      expect(chef_run).to create_yum_repository('rundeck')
    end

    it 'install packages' do
      expect(chef_run).to install_package('Rundeck Packages').with(
        package_name: %w(rundeck rundeck-config),
        version: %w(2.6.4-1.15.GA 2.6.4-1.15.GA),
        options: nil)
    end
  end

  context 'with Ubuntu' do
    let(:platform) { 'ubuntu' }
    let(:version) { '14.04' }

    it 'add apt repository' do
      expect(chef_run).to add_apt_repository('rundeck')
    end

    it 'install package' do
      expect(chef_run).to install_package('Rundeck Packages').with(
        package_name: %w(rundeck),
        version: %w(2.6.4),
        options: '--force-yes -o Dpkg::Options::="--force-confnew"')
    end
  end
end
