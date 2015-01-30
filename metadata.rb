name             'rundeck-server'
maintainer       'Robert Veznaver'
maintainer_email 'r.veznaver@criteo.com'
license          'Apache License 2.0'
description      'Installs rundeck and configure as needed'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends          'yum'
depends          'java'
depends          'build-essential'

suggests         'rundeck-bridge'
suggests         'rundeck-node'
