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

describe 'rundeck-test::job' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(
      step_into: [
        'rundeck_server_job',
      ]
    ).converge(described_recipe)
  }

  let(:response) {
    r = double('api-response')
    allow(r).to receive(:to_h) { {'failed' => {'count' => 0 } } }
    r
  }

  context "job does not exist" do

    it 'call api to create a job' do
      job = Rundeck::ObjectifiedHash.new( 'name' => 'test-job2', 'id' => 'abcde')
      client = double('rundeck-client')
      jobs = Rundeck::ObjectifiedHash.new('job' => [job.to_hash])
      expect(Rundeck).to receive(:client) { client }
      expect(client).to receive(:jobs).with('project', kind_of(Hash)) { jobs }
      expect(client).to receive(:import_jobs) { response }
      chef_run # evaluate chef_run
    end
  end

  context "job exists but is different" do

    it 'call api to modify a job' do
      job = Rundeck::ObjectifiedHash.new( 'name' => 'test-job', 'id' =>'abcde')
      client = double('rundeck-client')
      jobfull = Rundeck::ObjectifiedHash.new('uuid' => 'abcde' )
      jobs = Rundeck::ObjectifiedHash.new('job' => [job.to_hash])
      expect(Rundeck).to receive(:client) { client }
      expect(client).to receive(:jobs).with('project', kind_of(Hash)) { jobs }
      expect(client).to receive(:job).with('abcde', kind_of(Hash)) { jobfull}
      expect(client).to receive(:import_jobs).with(
        "- description: ''\n  loglevel: INFO\n  sequence:\n    commands:\n    - exec: a command\n  name: test-job\n  project: project\n  uuid: abcde\n",
        'yaml',
        kind_of(Hash)
      ) { response }
      chef_run # evaluate chef_run
    end
  end

  context "job exists and is correct" do

    it 'does not modify the job' do
      job = Rundeck::ObjectifiedHash.new( 'name' => 'test-job', 'id' => 'abcde')
      client = double('rundeck-client')
      jobfull = Rundeck::ObjectifiedHash.new('uuid' => 'abcde', 'description' => "", 'loglevel' => "INFO", 'sequence' => {'commands' => [{'exec' => "a command"}]}, 'name' => 'test-job', 'context' => { 'project' => 'project' })
      jobs = Rundeck::ObjectifiedHash.new('job' => [job.to_hash])
      expect(Rundeck).to receive(:client) { client }
      expect(client).to receive(:jobs).with('project', kind_of(Hash)) { jobs }
      expect(client).to receive(:job).with('abcde', kind_of(Hash)) { jobfull}
      expect(client).not_to receive(:import_jobs)
      chef_run # evaluate chef_run
    end
  end
end
