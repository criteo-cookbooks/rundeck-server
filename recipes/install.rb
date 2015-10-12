# Cookbook: rundeck-server
# Recipe:   install
#

include_recipe 'java' if node['rundeck_server']['install_java']

case node['platform_family']
when 'rhel', 'fedora'
  # Configure yum repo if specified
  yum_repository 'rundeck' do
    description node['rundeck_server']['yum']['description']
    baseurl node['rundeck_server']['yum']['baseurl']
    gpgcheck node['rundeck_server']['yum']['gpgcheck']
    gpgkey node['rundeck_server']['yum']['gpgkey']
    enabled node['rundeck_server']['yum']['enabled']
    action node['rundeck_server']['yum']['action']
  end
when 'debian'
  apt_repository 'rundeck' do
    uri node['rundeck_server']['apt']['uri']
    components node['rundeck_server']['apt']['components']
    key node['rundeck_server']['apt']['key']
    action node['rundeck_server']['apt']['action']
  end
end

# Install RunDeck package
package 'rundeck' do
  options node['rundeck_server']['apt']['options'] if node['platform_family'] == 'debian'
end
