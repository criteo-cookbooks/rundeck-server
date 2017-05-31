include_recipe 'rundeck-server'

rundeck_server_project 'test-project-ssh' do
  executor :ssh
  sources [
    { 'type'           => 'url',
      'config.url'     => 'http://chefserver_bridge:9980/',
      'config.timeout' => 30
    }
  ]
end

rundeck_server_project 'test-project-custom' do
  executor(
    provider: 'overthere-winrm',
    config: {
      'winrm-auth-type' => 'kerberos',
      'winrm-protocol'  => 'https'
    }
  )
  sources [
    { 'type'           => 'url',
      'config.url'     => 'http://chefserver_bridge:9980/',
      'config.timeout' => 30
    }
  ]
  properties({
    'foo': 'bar',
  })
end
