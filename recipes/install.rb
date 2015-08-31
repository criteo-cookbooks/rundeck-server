# Cookbook: rundeck-server
# Recipe:   install
#

include_recipe 'java' if node['rundeck_server']['install_java']

# Configure yum repo if specified
yum_repository 'rundeck' do
  description node['rundeck_server']['yum']['description']
  baseurl node['rundeck_server']['yum']['baseurl']
  gpgcheck node['rundeck_server']['yum']['gpgcheck']
  gpgkey node['rundeck_server']['yum']['gpgkey']
  enabled node['rundeck_server']['yum']['enabled']
  action node['rundeck_server']['yum']['action']
end

# Install RunDeck package
package 'rundeck' do
  action :install
end
