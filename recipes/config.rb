# Cookbook: rundeck-server
# Recipe:   config
#

# Install RunDeck plugins
unless node['rundeck_server']['plugins'].nil?
  node['rundeck_server']['plugins'].each do |name, source|
    extension = source['extension'] || File.extname(source['url'])
    remote_file name do
      source   source['url']
      path     "#{node['rundeck_server']['basedir']}/libext/#{name}#{extension}"
      mode     '0644'
      checksum source['checksum'] if source['checksum']
      backup   false
      notifies :restart, 'service[rundeckd]', :delayed
    end
  end
end

# Configure JAAS conf
template 'rundeck-jaas' do
  path     "#{node['rundeck_server']['confdir']}/jaas-loginmodule.conf"
  source   'jaas-loginmodule.conf.erb'
  variables(conf: node['rundeck_server']['jaas'])
  action :create
  sensitive true
  not_if   { node['rundeck_server']['jaas'].nil? }
  notifies :restart, 'service[rundeckd]', :delayed
end

# Configure ACL policies
node['rundeck_server']['aclpolicy'].each do |policy, configuration|
  template "rundeck-aclpolicy-#{policy}" do
    path     "#{node['rundeck_server']['confdir']}/#{policy}.aclpolicy"
    source   'aclpolicy.erb'
    variables(conf: configuration)
    helpers(MashToHash)
    action   :create
    not_if   { configuration.nil? }
  end
end

# Configure hostname
template ::File.join(node['rundeck_server']['confdir'], 'rundeck-config.properties') do
  source   'properties.erb'
  mode     '0644'
  sensitive true
  notifies :restart, 'service[rundeckd]', :delayed
  variables(properties: node['rundeck_server']['rundeck-config.properties'])
end

template 'rundeck-profile' do
  path     ::File.join(node['rundeck_server']['confdir'], 'profile')
  source   'profile.erb'
  owner    'rundeck'
  group    'rundeck'
  mode     '0644'
  sensitive true
  variables(basedir: node['rundeck_server']['basedir'],
            jvm:     node['rundeck_server']['jvm'])
  notifies :restart, 'service[rundeckd]', :delayed
end

template 'rundeck-framework-properties' do
  path     ::File.join(node['rundeck_server']['confdir'], 'framework.properties')
  source   'properties.erb'
  owner    'rundeck'
  group    'rundeck'
  mode     '0644'
  sensitive true
  variables(properties: node['rundeck_server']['rundeck-config.framework'])
  notifies :restart, 'service[rundeckd]'
end

template 'realm.properties' do
  path     ::File.join(node['rundeck_server']['confdir'], 'realm.properties')
  source   'properties.erb'
  owner    'rundeck'
  group    'rundeck'
  mode     '0644'
  sensitive true
  variables(properties: node['rundeck_server']['realm.properties'])
  notifies :restart, 'service[rundeckd]'
end

# Configure Log4J
template ::File.join(node['rundeck_server']['confdir'], 'log4j.properties') do
  source   'properties.erb'
  mode     '0644'
  notifies :restart, 'service[rundeckd]', :delayed
  variables(properties: node['rundeck_server']['log4j.properties'])
end
