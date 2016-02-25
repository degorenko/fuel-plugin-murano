notice('MURANO PLUGIN: logging-murano.pp')

include ::rsyslog::params

file { "${::rsyslog::params::rsyslog_d}53-murano.conf":
  ensure => present,
  content => template('detach-murano/53-murano.conf.erb'),
  notify  => Service[$::rsyslog::params::service_name],
}

if !defined(Service[$::rsyslog::params::service_name]) {
  service { $::rsyslog::params::service_name:
    ensure => 'running',
    enable => true,
  }
}

File["${::rsyslog::params::rsyslog_d}53-murano.conf"] ~> Service[$::rsyslog::params::service_name]

file_line { 'murano_logrotate':
  line  => "\"/var/log/murano/*.log\"",
  after => "\"/var/log/sudo.log\"",
  path  => '/etc/logrotate.d/fuel.nodaily',
}
