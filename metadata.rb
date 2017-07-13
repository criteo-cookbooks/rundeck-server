name             'rundeck-server'
maintainer       'Robert Veznaver'
maintainer_email 'r.veznaver@criteo.com'
license          'Apache License 2.0'
description      'Installs rundeck and configure as needed'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.4.2'
supports         'centos'

depends          'yum', '< 5.0.0' # still uses yum_repositories from yum
depends          'java'

suggests         'rundeck-bridge'
suggests         'rundeck-node'

source_url 'https://github.com/criteo-cookbooks/rundeck-server' if defined?(source_url)
issues_url 'https://github.com/criteo-cookbooks/rundeck-server/issues' if defined?(issues_url)
