name             'rundeck-server'
maintainer       'Robert Veznaver'
maintainer_email 'r.veznaver@criteo.com'
license          'Apache License 2.0'
description      'Installs rundeck and configure as needed'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.1'

%w(ubuntu centos amazon redhat).each do |os|
  supports os
end

depends          'yum'
depends          'java'
depends          'apt'

suggests         'rundeck-bridge'
suggests         'rundeck-node'
