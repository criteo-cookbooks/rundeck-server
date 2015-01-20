# Cookbook: rundeck-server
# Recipe:   config
#

include_recipe 'java'
include_recipe 'augeas::geminstall'

# Configure yum repo if specified
yum_repository 'rundeck' do
  description 'Rundeck official repo'
  baseurl     node['rundeck_server']['repo']
  gpgcheck    false
  action      :create
end

# Install RunDeck package
package 'rundeck' do
  action :install
end

# Install RunDeck plugins
unless node['rundeck_server']['plugins'].nil?
  node['rundeck_server']['plugins'].each do |name, source|
    remote_file name do
      source   source['url']
      path     "#{node['rundeck_server']['basedir']}/libext/#{name}.jar"
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
  action   :create
  not_if   { node['rundeck_server']['jaas'].nil? }
  notifies :restart, 'service[rundeckd]', :delayed
end

# Configure ACL policies
node['rundeck_server']['aclpolicy'].each do |policy, configuration|
  template "rundeck-aclpolicy-#{policy}" do
    path     "#{node['rundeck_server']['confdir']}/#{policy}.aclpolicy"
    source   'aclpolicy.erb'
    variables(conf: configuration)
    action   :create
    not_if   { configuration.nil? }
    notifies :restart, 'service[rundeckd]', :delayed
  end
end

# Configure hostname
template ::File.join(node['rundeck_server']['confdir'], 'rundeck-config.properties') do
  source 'properties.erb'
  mode '0644'
  notifies :restart, 'service[rundeckd]', :delayed
  variables(properties: node['rundeck_server']['rundeck-config.properties'])
end

# security-role/role-name workaround
# https://github.com/rundeck/rundeck/wiki/Faq#i-get-an-error-logging-in-http-error-403--reason-role
augeas 'rundeck-security-role' do
  changes  "set /files/#{node['rundeck_server']['basedir']}/exp/webapp/WEB-INF/web.xml/web-app/security-role/role-name/#text #{node['rundeck_server']['rolename']}"
  lens     'xml.lns'
  incl     "#{node['rundeck_server']['basedir']}/exp/webapp/WEB-INF/web.xml"
  notifies :restart, 'service[rundeckd]', :delayed
end

template ::File.join(node['rundeck_server']['confdir'], 'profile') do
  source 'profile.erb'
  mode '0644'
  notifies :restart, 'service[rundeckd]', :delayed
end
