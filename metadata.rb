name             'rundeck-server'
maintainer       'Criteo'
maintainer_email 'use_github_issues@criteo.com'
license          'Apache License 2.0'
description      'Installs rundeck and configure as needed'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.5.0'
supports         'centos'

depends          'yum'
depends          'java'

suggests         'rundeck-bridge'
suggests         'rundeck-node'

source_url 'https://github.com/criteo-cookbooks/rundeck-server' if defined?(source_url)
issues_url 'https://github.com/criteo-cookbooks/rundeck-server/issues' if defined?(issues_url)
