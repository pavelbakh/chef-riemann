name             'riemann'
maintainer       'Pavel Bakhmetev'
maintainer_email 'pavelbakh@yahoo.com'
license          'All rights reserved'
description      'Installs/Configures riemann server and dashboard'
long_description 'Installs/Configures riemann server and dashboard'
version          '1.0.2'

supports "Centos", ">= 6.5"

depends "build-essential"
depends "yum-epel"
depends "iptables-ng"

recipe "riemann::server", "Riemann server"
recipe "riemann::dashboard", "Riemann dashboard"


attribute 'riemann/server/version',
  :display_name => "Server version",
  :description => "Riemann server version to install",
  :type => "string",
  :default => "0.2.9"

attribute 'riemann/server/user',
  :display_name => 'Riemann system user',
  :description => 'Name of the riemann server system user',
  :type => 'string',
  :default => 'riemann'

attribute 'riemann/server/home',
  :display_name => 'Riemann server home',
  :description => 'Home directory for the riemann server user',
  :type => 'string',
  :default => '/var/lib/riemann'

attribute 'riemann/server/config_directory',
  :display_name => 'Riemann config directory',
  :description => 'Where to put riemann.config. Should not be modified but can be useful for external cookbook to put a custom riemann.config',
  :type => 'string',
  :default => '/etc/riemann'

attribute 'riemann/server/bind_ip',
  :display_name => 'Riemann server bind address',
  :description => 'The IP address to bind riemann server on',
  :type => 'string',
  :default => '0.0.0.0'

attribute 'riemann/server/listen_port',
  :display_name => 'Riemann listen port',
  :type => 'string',
  :default => '5555'

attribute 'riemann/server/websocket_port',
  :display_name => 'Riemann websocket port',
  :type => 'string',
  :default => '5556'

attribute 'riemann/dashboard/port',
  :display_name => 'Riemann dashboard TCP port',
  :type => 'string',
  :default => '4567'

attribute 'riemann/dashboard/bind_ip',
  :display_name => 'Riemann dashboard bind address',
  :type => 'string',
  :default => '0.0.0.0'

attribute 'riemann/dashboard/user',
  :display_name => 'Riemann dashboard user',
  :description => 'Riemann dashboard system user name',
  :type => 'string',
  :default => 'riemann-dash'

attribute 'riemann/dashboard/home',
  :display_name => 'Riemann dash install dir',
  :description => 'The place where the riemann-dash bundle and configuration will be installed.',
  :type => 'string',
  :default => '/var/lib/riemann-dash'
