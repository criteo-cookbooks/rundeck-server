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

chef_gem 'rundeck'
