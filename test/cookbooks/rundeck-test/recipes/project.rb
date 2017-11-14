include_recipe 'rundeck-server'

rundeck_server_project 'test-project-ssh' do
  executor :ssh
  sources [
    { 'type'           => 'url',
      'config.url'     => 'http://chefserver_bridge:9980/',
      'config.timeout' => 30
    }
  ]
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
