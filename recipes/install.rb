# Cookbook: rundeck-server
# Recipe:   install
#

include_recipe 'java' if node['rundeck_server']['install_java']

case node['platform_family']
when 'rhel', 'fedora'
  pkg_type = 'yum'

  yum_repository 'rundeck' do
    description node['rundeck_server']['yum']['description']
    baseurl node['rundeck_server']['yum']['baseurl']
    gpgcheck node['rundeck_server']['yum']['gpgcheck']
    gpgkey node['rundeck_server']['yum']['gpgkey']
    enabled node['rundeck_server']['yum']['enabled']
    action node['rundeck_server']['yum']['action']
  end

when 'debian'
  pkg_type = 'apt'

  apt_repository 'rundeck' do
    uri node['rundeck_server']['apt']['uri']
    components node['rundeck_server']['apt']['components']
    key node['rundeck_server']['apt']['key']
    action node['rundeck_server']['apt']['action']
  end

else
  raise 'Unsupported platform'
end

# Install RunDeck packages
package 'Rundeck Packages'  do
  package_name    node['rundeck_server']['packages'][pkg_type].keys
  version         node['rundeck_server']['packages'][pkg_type].values
  options         node['rundeck_server'][pkg_type]['options']
  action          :install
end
