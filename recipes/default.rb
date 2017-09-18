#
# Cookbook: rundeck-server
# Recipe:   default
#
=begin
#<
This recipe call config recipe and setup rundeck-server service
It also install rundeck gem to allow to configure rundeck via ruby
#>
=end

include_recipe 'rundeck-server::install'
include_recipe 'rundeck-server::config'

# Define service
service 'rundeckd' do
  supports status: true, restart: true
  action [:enable, :start]
end


execute 'ensure api is up' do
  command "curl -k -s -f #{node['rundeck_server']['rundeck-config.framework']['framework.server.url']}"
  retries 10
  retry_delay 30
end

# Install rundeck gem for API communication
chef_gem 'rundeck' do
  version '>= 1.1.0'
  compile_time false
end
