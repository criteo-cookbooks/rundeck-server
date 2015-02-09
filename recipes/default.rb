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

# Install rundeck gem for API communication
chef_gem 'rundeck' do
  version '>= 1.1.0'
end
