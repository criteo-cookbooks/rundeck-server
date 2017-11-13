include_recipe 'rundeck-server'

# Create an API token for the admin user
file ::File.join(node['rundeck_server']['confdir'], 'token.properties') do
  owner    'rundeck'
  group    'rundeck'
  mode     '0600'
  content  'admin:dummy-token'
  notifies :restart, 'service[rundeckd]'
end

# Create a dummy project
rundeck_server_project 'dummy-project' do
  executor :ssh
  sources [
    { 'type'           => 'url',
      'config.url'     => 'http://localhost:9980/',
      'config.timeout' => 30
    }
  ]
  scm_import('config.strictHostKeyChecking' => 'no')
  scm_export('config.strictHostKeyChecking' => 'no')
  nodes [{ 'name' => 'localhost',
       'description' => 'localhost',
       'tags' => '',
       'hostname' => 'localhost',
       'osArch' => 'amd64',
       'osFamily' => 'unix',
       'osName' => 'Linux',
       'osVersion' => '3.10.0-327.el7.x86_64' },
      ]
end

# Create a dummy job
#
# Will not create a job on the first converge
# because of the guard
#
rundeck_server_job 'dummy-job' do
  project   'dummy-project'
  api_token 'dummy-token'
  endpoint  'http://localhost:4440'
  config(
    description: 'Dummy description',
    loglevel:    'INFO',
    sequence: {
      keepgoing: false,
      strategy:  'node-first',
      commands: [
        exec: 'Dummy command'
      ]
    })
  only_if 'curl --silent --fail --insecure http://localhost:4440'
end

# Create a test project
rundeck_server_project 'Test' do
  executor :ssh
  sources [
    { 'type'           => 'url',
      'config.url'     => 'http://localhost:9980/',
      'config.timeout' => 30
    }
  ]
  scm_import('config.strictHostKeyChecking' => 'no')
  scm_export('config.strictHostKeyChecking' => 'no')
  nodes [{ 'name' => 'localhost',
       'description' => 'localhost',
       'tags' => '',
       'hostname' => 'localhost',
       'osArch' => 'amd64',
       'osFamily' => 'unix',
       'osName' => 'Linux',
       'osVersion' => '3.10.0-327.el7.x86_64' },
      ]
end

# Generalised job import
node['rundeck_test']['jobs'].map do |project, jobs|
  jobs.map do |name, conf|
    rundeck_server_job name do
      project   project
      api_token 'dummy-token'
      endpoint  'http://localhost:4440'
      config    conf
      only_if   'curl --silent --fail --insecure http://localhost:4440'
    end
  end
end
