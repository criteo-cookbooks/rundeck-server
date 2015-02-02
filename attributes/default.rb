#
# Cookbook:   rundeck-server
# Attributes: default
#

# This depends on the package used
default['rundeck_server']['confdir'] = '/etc/rundeck'
default['rundeck_server']['basedir'] = '/var/lib/rundeck'
default['rundeck_server']['datadir'] = '/var/rundeck'

# Hostname has to be set up
default['rundeck_server']['port']['http']    = 4440
default['rundeck_server']['port']['https']   = 4443
default['rundeck_server']['port']['default'] = node['rundeck_server']['port']['http']

# Default security-role/role-name allowed to authenticate
# https://github.com/rundeck/rundeck/wiki/Faq#i-get-an-error-logging-in-http-error-403--reason-role
default['rundeck_server']['rolename'] = 'user'

# session timeout in the UI (in minutes)
default['rundeck_server']['session_timeout'] = 30

# Repository containing the rundeck package
default['rundeck_server']['repo'] = 'http://dl.bintray.com/rundeck/rundeck-rpm/'

# Plugin list to install
default['rundeck_server']['plugins']['winrm']['url'] = 'https://github.com/rundeck-plugins/rundeck-winrm-plugin/releases/download/v1.2/rundeck-winrm-plugin-1.2.jar'

# --[ RDECK_JVM configuration ]--
default['rundeck_server']['rdeck_jvm']['loginmodule.name']                = 'RDpropertyfilelogin'
default['rundeck_server']['rdeck_jvm']['rdeck.config']                    = node['rundeck_server']['confdir']
default['rundeck_server']['rdeck_jvm']['rundeck.server.configDir']        = node['rundeck_server']['confdir']
default['rundeck_server']['rdeck_jvm']['rundeck.server.serverDir']        = node['rundeck_server']['basedir']
default['rundeck_server']['rdeck_jvm']['rdeck.base']                      = node['rundeck_server']['basedir']        # Default is the directory containing the launcher jar
default['rundeck_server']['rdeck_jvm']['server.http.host']                = '0.0.0.0'                                    # Address/hostname to listen on, default is "0.0.0.0"
default['rundeck_server']['rdeck_jvm']['server.http.port']                = node['rundeck_server']['port']['http']   # The HTTP port to use for the server, default "4440"
default['rundeck_server']['rdeck_jvm']['server.https.port']               = node['rundeck_server']['port']['https']  # The HTTPS port to use or the server, default "4443"
default['rundeck_server']['rdeck_jvm']['java.io.tmpdir']                  = ::File.join('tmp', 'rundeck')
default['rundeck_server']['rdeck_jvm']['server.datastore.path']           = ::File.join(node['rundeck_server']['basedir'], 'data')                  # Path to server datastore dir
default['rundeck_server']['rdeck_jvm']['java.security.auth.login.config'] = ::File.join(node['rundeck_server']['confdir'], 'jaas-loginmodule.conf')
default['rundeck_server']['rdeck_jvm']['rdeck.projects']                  = ::File.join(node['rundeck_server']['datadir'], 'projects')
default['rundeck_server']['rdeck_jvm']['rdeck.runlogs']                   = ::File.join(node['rundeck_server']['basedir'], 'logs')
default['rundeck_server']['rdeck_jvm']['rundeck.config.location']         = ::File.join(node['rundeck_server']['confdir'], 'rundeck-config.properties')

# The JAAS login configuration file with one entry and multiple modules may be
# generated from this attribute. Check out Oracle JAAS documentation at:
# http://docs.oracle.com/javase/8/docs/technotes/guides/security/jgss/tutorials/LoginConfigFile.html
default['rundeck_server']['jaas'] = [{
  module:  'org.eclipse.jetty.plus.jaas.spi.PropertyFileLoginModule',
  flag:    'required',
  options: {
    debug: 'true',
    file:  '/etc/rundeck/realm.properties',
  },
}]

# --[ rundeck-config.properties configuration ]--
default['rundeck_server']['rundeck-config.properties']['loglevel.default'] = 'INFO'
default['rundeck_server']['rundeck-config.properties']['rdeck.base']       = node['rundeck_server']['basedir']
default['rundeck_server']['rundeck-config.properties']['rss.enabled']      = false
default['rundeck_server']['rundeck-config.properties']['grails.serverURL'] = "http://localhost:#{node['rundeck_server']['port']['default']}"

# The admin ACL policy in YAML is generated from this attribute.
# Check out the docs at: http://rundeck.org/docs/man5/aclpolicy.html
default['rundeck_server']['aclpolicy']['admin'] = [{
  description: 'Admin, all access.',
  context: {
    project: '.*',
  },
  for: {
    resource: [{ allow: '*' }],
    adhoc:    [{ allow: '*' }],
    job:      [{ allow: '*' }],
    node:     [{ allow: '*' }],
  },
  by: {
    group:    ['admin'],
  },
}, {
  description: 'Admin, all access.',
  context: {
    application: 'rundeck',
  },
  for: {
    resource: [{ allow: '*' }],
    project:  [{ allow: '*' }],
    storate:  [{ allow: '*' }],
  },
  by: {
    group:    ['admin'],
  },
}]

default['rundeck_server']['rundeck-config.framework']['framework.server.name']      = 'localhost'
default['rundeck_server']['rundeck-config.framework']['framework.server.hostname']  = 'localhost'
default['rundeck_server']['rundeck-config.framework']['framework.server.port']      = 4440
default['rundeck_server']['rundeck-config.framework']['framework.server.url']       = 'http://localhost:4440'
default['rundeck_server']['rundeck-config.framework']['framework.server.username']  = 'admin'
default['rundeck_server']['rundeck-config.framework']['framework.server.password']  = 'admin'
default['rundeck_server']['rundeck-config.framework']['rdeck.base']                 = '/var/lib/rundeck'
default['rundeck_server']['rundeck-config.framework']['framework.projects.dir']     = '/var/rundeck/projects'
default['rundeck_server']['rundeck-config.framework']['framework.etc.dir']          = '/etc/rundeck'
default['rundeck_server']['rundeck-config.framework']['framework.var.dir']          = '/var/lib/rundeck/var'
default['rundeck_server']['rundeck-config.framework']['framework.tmp.dir']          = '/var/lib/rundeck/var/tmp'
default['rundeck_server']['rundeck-config.framework']['framework.logs.dir']         = '/var/lib/rundeck/logs'
default['rundeck_server']['rundeck-config.framework']['framework.libext.dir']       = '/var/lib/rundeck/libext'
default['rundeck_server']['rundeck-config.framework']['framework.ssh.keypath']      = '/var/lib/rundeck/.ssh/id_rsa'
default['rundeck_server']['rundeck-config.framework']['framework.ssh.user']         = 'rundeck'
default['rundeck_server']['rundeck-config.framework']['framework.ssh.timeout']      = 0

default['build-essential']['compile_time'] = true
default['libxml2']['compile_time'] = true
