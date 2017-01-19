source 'https://rubygems.org'

gem 'berkshelf'
gem 'chef',       '>= 12.1.0'
gem 'chefspec',   '>= 4.2'
gem 'fauxhai',    '>= 2.2'
gem 'foodcritic', '>= 4.0'
gem 'rake'

# TODO: Check why build is failing for rspec-mocks > 3.4.0
gem 'rspec-mocks', '= 3.4.0'

gem 'kitchen-vagrant'
gem 'test-kitchen'

gem 'rundeck', '>= 1.1.0'

group :ec2 do
  gem 'kitchen-ec2', git: 'https://github.com/criteo-forks/kitchen-ec2.git', branch: 'criteo'
  gem 'winrm',      '~> 1.6'
  gem 'winrm-fs',   '~> 0.3'
end
