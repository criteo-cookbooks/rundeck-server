require_relative '../spec_helper'

describe 'rundeck-server' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'download winrm plugin' do
    expect(chef_run).to create_remote_file('winrm')
      .with_path('/var/lib/rundeck/libext/winrm.jar')
      .with_checksum(nil)
  end

  it 'enable rundeckd service' do
    expect(chef_run).to enable_service('rundeckd')
  end

  it 'create template' do
    expect(chef_run).to create_template('rundeck-jaas')
  end

  it 'check default template content' do
    expect(chef_run).to render_file('rundeck-jaas')
      .with_content('org.eclipse.jetty.plus.jaas.spi.PropertyFileLoginModule')
  end

  it 'simple default admin aclpolicy yaml content' do
    expect(chef_run).to render_file('rundeck-aclpolicy-admin')
      .with_content(/- allow: ['"]\*['"]/)
  end
end

describe 'rundeck-server' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['rundeck_server']['plugins']['winrm']['checksum'] =
        '54500ae1db500f7be2e0468d6f464c1f7f28c5aa4c7c2e7f0cb3a5cfa0386824'
    end.converge(described_recipe)
  end

  it 'download winrm plugin with optional checksum' do
    expect(chef_run).to create_remote_file('winrm')
      .with_path('/var/lib/rundeck/libext/winrm.jar')
      .with_checksum('54500ae1db500f7be2e0468d6f464c1f7f28c5aa4c7c2e7f0cb3a5cfa0386824')
  end
end
