#
# Cookbook: rundeck-server
# Recipe:   default
#

include_recipe 'rundeck-server::config'

# Define service
service 'rundeckd' do
  supports status: true, restart: true
  action   [:enable, :start]
end

# Install build essential at compile time for gem compilation
node.default['build-essential']['compile_time'] = true
include_recipe 'build-essential'

# Install rundeck gem for API communication
chef_gem 'rundeck'
