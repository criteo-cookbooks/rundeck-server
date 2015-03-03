# Cookbook: rundeck-server
# Recipe:   config
#

include_recipe 'java'

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
require 'rexml/document'
web_xml = "#{node['rundeck_server']['basedir']}/exp/webapp/WEB-INF/web.xml"

web_xml_update = {
  'web-app/security-role/role-name'        => node['rundeck_server']['rolename'],
  'web-app/session-config/session-timeout' => node['rundeck_server']['session_timeout'],
}

ruby_block 'web-xml-update' do # ~FC022
  block do
    ::File.open(web_xml, 'r+') do |file|
      doc = REXML::Document.new(file)
      web_xml_update.each do |xpath, text|
        doc.elements.to_a(xpath).first.text = text
      end
      # Go to the beginning of file
      file.rewind
      doc.write(file)
    end
  end
  not_if do
    elements = REXML::Document.new(::File.new(web_xml)).elements
    web_xml_update.all? do |xpath, text|
      elements.to_a(xpath).first.text == text.to_s
    end
  end
  notifies :restart, 'service[rundeckd]', :delayed
end

template 'rundeck-profile' do
  path     ::File.join(node['rundeck_server']['confdir'], 'profile')
  source   'profile.erb'
  owner    'rundeck'
  group    'rundeck'
  mode     '0644'
  variables(http_port:  node['rundeck_server']['port']['http'],
            https_port: node['rundeck_server']['port']['https'],
            basedir:    node['rundeck_server']['basedir'],
            jvm:        node['rundeck_server']['jvm'])
  notifies :restart, 'service[rundeckd]', :delayed
end

template 'rundeck-framework-properties' do
  path     ::File.join(node['rundeck_server']['confdir'], 'framework.properties')
  source   'properties.erb'
  owner    'rundeck'
  group    'rundeck'
  mode     '0644'
  variables(properties: node['rundeck_server']['rundeck-config.framework'])
  notifies :restart, 'service[rundeckd]'
end
