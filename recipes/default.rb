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
include_recipe 'build-essential'
include_recipe 'libxml2'

# Install rundeck gem for API communication
chef_gem 'rundeck'
