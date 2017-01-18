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

# Install rundeck gem for API communication
chef_gem 'rundeck' do
  version '>= 1.1.0'
  compile_time false
end
