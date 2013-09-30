####################################
# Provision!
# Probably dont need to edit this
####################################

# Import config.pp for easy settings
import 'config.pp'

group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }
File { owner => 0, group => 0, mode => 0644 }

class {'apt':
  always_apt_update => true,
}

Class['::apt::update'] -> Package <|
    title != 'python-software-properties'
and title != 'software-properties-common'
|>

    apt::key { '4F4EA0AAE5267A6C': }

apt::ppa { 'ppa:ondrej/php5-oldstable':
  require => Apt::Key['4F4EA0AAE5267A6C']
}

class { 'puphpet::dotfiles': }

package { [
    'build-essential',
    'vim',
    'curl',
    'git-core'
  ]:
  ensure  => 'installed',
}

class { 'apache': }

apache::dotconf { 'custom':
  content => 'EnableSendfile Off',
}

apache::module { 'rewrite': }

apache::vhost { 'default':
  docroot       => '/var/www/',
  server_name   => false,
  priority      => '',
  directory_allow_override => 'All',
  template => 'apache/virtualhost/vhost.conf.erb',
}

# Named vhost
apache::vhost { $vhost_name:
  docroot       => '/var/www/',
  server_name   => $vhost_server,
  port          => '80',
  serveraliases => [
    $vhost_alias,
  ],
  directory_allow_override => 'All',
  priority      => '1',
}

class { 'php':
  service             => 'apache',
  service_autorestart => false,
  module_prefix       => '',
}

php::module { 'php5-mysql': }
php::module { 'php5-cli': }
php::module { 'php5-curl': }
php::module { 'php5-intl': }
php::module { 'php5-mcrypt': }

class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}

class { 'xdebug':
  service => 'apache',
}

class { 'composer':
  require => Package['php5', 'curl'],
}

puphpet::ini { 'xdebug':
  value   => [
    'xdebug.default_enable = 1',
    'xdebug.remote_autostart = 0',
    'xdebug.remote_connect_back = 1',
    'xdebug.remote_enable = 1',
    'xdebug.remote_handler = "dbgp"',
    'xdebug.remote_port = 9000'
  ],
  ini     => '/etc/php5/conf.d/zzz_xdebug.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

puphpet::ini { 'php':
  value   => [
    'date.timezone = "Europe/London"'
  ],
  ini     => '/etc/php5/conf.d/zzz_php.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

puphpet::ini { 'custom':
  value   => [
    'display_errors = On',
    'error_reporting = -1'
  ],
  ini     => '/etc/php5/conf.d/zzz_custom.ini',
  notify  => Service['apache'],
  require => Class['php'],
}

class { 'mysql::server':
  config_hash   => { 'root_password' => 'root' }
}

# mysql::db { 'database':
#   grant    => [
#     'ALL'
#   ],
#   user     => 'root',
#   password => 'root',
#   host     => 'localhost',
#   sql      => '/var/www/db/database.sql',
#   charset  => 'utf8',
#   require  => Class['mysql::server'],
# }

mysql::db { $db_name:
  grant    => [
    'ALL'
  ],
  user     => $db_user,
  password => $db_pass,
  host     => $db_host,
  sql      => $db_sql,
  charset  => 'utf8',
  require  => Class['mysql::server'],
}
