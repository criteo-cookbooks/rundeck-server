require_relative '../spec_helper'

describe 'rundeck-test::default' do
  mock_web_xml

  let(:chef_run) { ChefSpec::SoloRunner.new(
    step_into: ['rundeck_server_project']
  ).converge(described_recipe) }

  it 'creates project properties file' do
    expect(chef_run).to render_file('/var/rundeck/projects/test-project-ssh/etc/project.properties')
      .with_content('http\://chefserver_bridge\:9980')
  end
end
