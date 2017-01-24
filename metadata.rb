name             'rundeck-server'
maintainer       'Robert Veznaver'
maintainer_email 'r.veznaver@criteo.com'
license          'Apache License 2.0'
description      'Installs rundeck and configure as needed'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.3.1'
supports         'centos'

depends          'yum'
depends          'java'

suggests         'rundeck-bridge'
suggests         'rundeck-node'

source_url 'https://github.com/criteo-cookbooks/rundeck-server'
issues_url 'https://github.com/criteo-cookbooks/rundeck-server/issues'
