use_inline_resources

action :create do
  %w(etc var).each do |d|
    directory ::File.join(node['rundeck_server']['datadir'], 'projects', new_resource.name, d) do
      user  'rundeck'
      group 'rundeck'
      mode '0770'
      recursive true
    end
  end

  properties = {}
  properties.merge!(new_resource.properties)
  properties['project.name'] = new_resource.name

  executor = new_resource.executor
  if executor.is_a? Symbol
    # Template executor config
    case executor
    when :ssh
      executor = {
        provider: 'jsch-ssh',
        config: {
          'ssh-authentication'  => 'privateKey',
          'ssh-keypath'         => "#{node['rundeck_server']['basedir']}/.ssh/id_rsa"
        }
      }
    when :winrm
      fail 'WinRM template not yet supported'
    else
      fail "Unknown executor template: #{new_resource.executor}"
    end
  end

  properties['service.NodeExecutor.default.provider'] = executor[:provider] || executor['provider']
  (executor[:config] || executor['config']).each do |key, value|
    properties["project.#{key}"] = value
  end

  new_resource.sources.each_with_index do |source, i|
    source.each do |k, v|
      properties["resources.source.#{i + 1}.#{k}"] = v
    end
  end
  properties['service.FileCopier.default.provider'] = 'jsch-scp'

  template ::File.join(node['rundeck_server']['datadir'], 'projects', new_resource.name, 'etc', 'project.properties') do
    source   'properties.erb'
    user     'rundeck'
    group    'rundeck'
    mode     '0660'
    cookbook new_resource.cookbook
    variables(properties: properties)
  end
end

action :delete do
  directory ::File.join(node['rundeck_server']['datadir'], 'projects', new_resource.name) do
    recursive true
    action :delete
  end
end
