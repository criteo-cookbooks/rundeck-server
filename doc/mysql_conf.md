Mysql conf example
------------------

If you need to connect rundeck to a mysql example, you simply have to put:

- default['rundeck_server']['rundeck-config.properties']['dataSource.url']      = 'jdbc:mysql://localhost/rundeckdb?autoReconnect=true'
- default['rundeck_server']['rundeck-config.properties']['dataSource.username'] = 'rundeck'
- default['rundeck_server']['rundeck-config.properties']['dataSource.password'] = 'secret'

See rundeck doc for more information.
