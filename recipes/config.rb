# Cookbook: rundeck-server
# Recipe:   config
#
rundeck_server_attributes = node['rundeck_server']
databag_name = rundeck_server_attributes['databag']['name']
databag_item_name = rundeck_server_attributes['databag']['item']
jaas_attributes = [] + rundeck_server_attributes['jaas']
config_framework_attributes = {}.merge!(rundeck_server_attributes['rundeck-config.framework'])
config_properties_attributes = {}.merge!(rundeck_server_attributes['rundeck-config.properties'])
realm_properties_attributes = {}.merge!(rundeck_server_attributes['realm.properties'])

# Pull items from data bag if it exists. This is optional
secrets = begin
            data_bag(databag_name)
            data_bag_item(databag_name, databag_item_name)
          rescue
            Chef::Log.info("Databag #{databag_name} not found")
            nil
          end

# If the data bag exists and has correct properties, merge those properties
# with the existing node attribtues for this run
if secrets
  config_framework_attributes.merge!(secrets['rundeck-config.framework']) unless secrets['rundeck-config.framework'].nil?
  config_properties_attributes.merge!(secrets['rundeck-config.properties']) unless secrets['rundeck-config.properties'].nil?
  realm_properties_attributes.merge!(secrets['realm.properties']) unless secrets['realm.properties'].nil?
  (jaas_attributes + secrets['jaas']).uniq unless secrets['jaas'].nil?
end

# Install RunDeck plugins
unless rundeck_server_attributes['plugins'].nil?
  rundeck_server_attributes['plugins'].each do |name, source|
    remote_file name do
      source   source['url']
      path     "#{rundeck_server_attributes['basedir']}/libext/#{name}.jar"
      mode     '0644'
      checksum source['checksum'] if source['checksum']
      backup   false
      notifies :restart, 'service[rundeckd]', :delayed
    end
  end
end

# Configure JAAS conf
template 'rundeck-jaas' do
  path     "#{rundeck_server_attributes['confdir']}/jaas-loginmodule.conf"
  source   'jaas-loginmodule.conf.erb'
  variables(conf: jaas_attributes)
  action :create
  sensitive true
  not_if   { rundeck_server_attributes['jaas'].nil? }
  notifies :restart, 'service[rundeckd]', :delayed
end

# Configure ACL policies
rundeck_server_attributes['aclpolicy'].each do |policy, configuration|
  template "rundeck-aclpolicy-#{policy}" do
    path     "#{rundeck_server_attributes['confdir']}/#{policy}.aclpolicy"
    source   'aclpolicy.erb'
    variables(conf: configuration)
    action   :create
    not_if   { configuration.nil? }
  end
end

# Configure hostname
template ::File.join(rundeck_server_attributes['confdir'], 'rundeck-config.properties') do
  source   'properties.erb'
  mode     '0644'
  sensitive true
  notifies :restart, 'service[rundeckd]', :delayed
  variables(properties: config_properties_attributes)
end

# Configure thread pool
file 'rundeck-quartz-properties' do
  path    "#{rundeck_server_attributes['basedir']}/exp/webapp/WEB-INF/classes/quartz.properties"
  content "org.quartz.threadPool.threadCount = #{rundeck_server_attributes['threadcount']}\n"
  owner   'rundeck'
  group   'rundeck'
  mode    '0644'
end

# security-role/role-name workaround
# https://github.com/rundeck/rundeck/wiki/Faq#i-get-an-error-logging-in-http-error-403--reason-role
require 'rexml/document'
web_xml = "#{rundeck_server_attributes['basedir']}/exp/webapp/WEB-INF/web.xml"

web_xml_update = {
  'web-app/security-role/role-name'        => rundeck_server_attributes['rolename'],
  'web-app/session-config/session-timeout' => rundeck_server_attributes['session_timeout']
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
  path     ::File.join(rundeck_server_attributes['confdir'], 'profile')
  source   'profile.erb'
  owner    'rundeck'
  group    'rundeck'
  mode     '0644'
  variables(basedir: rundeck_server_attributes['basedir'],
            jvm:     rundeck_server_attributes['jvm'])
  notifies :restart, 'service[rundeckd]', :delayed
end

template 'rundeck-framework-properties' do
  path     ::File.join(rundeck_server_attributes['confdir'], 'framework.properties')
  source   'properties.erb'
  owner    'rundeck'
  group    'rundeck'
  mode     '0644'
  sensitive true
  variables(properties: config_framework_attributes)
  notifies :restart, 'service[rundeckd]'
end

template 'realm.properties' do
  path     ::File.join(rundeck_server_attributes['confdir'], 'realm.properties')
  source   'properties.erb'
  owner    'rundeck'
  group    'rundeck'
  mode     '0644'
  sensitive true
  variables(properties: realm_properties_attributes)
  notifies :restart, 'service[rundeckd]'
end

# Configure Log4J
template ::File.join(rundeck_server_attributes['confdir'], 'log4j.properties') do
  source   'properties.erb'
  mode     '0644'
  notifies :restart, 'service[rundeckd]', :delayed
  variables(properties: rundeck_server_attributes['log4j.properties'])
end
