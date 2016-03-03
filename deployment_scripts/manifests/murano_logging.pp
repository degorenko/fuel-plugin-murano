notice('MURANO PLUGIN: logging-murano.pp')

$content=':syslogtag, contains, "murano" -/var/log/murano-all.log\n
### stop further processing for the matched entries\n
& ~'

include ::rsyslog::params

::rsyslog::snippet { '55-murano':
  content => $content,
}

if !defined(Service[$::rsyslog::params::service_name]) {
  service { $::rsyslog::params::service_name:
    ensure => 'running',
    enable => true,
  }
}

Rsyslog::Snippet['55-murano'] ~> Service[$::rsyslog::params::service_name]

file_line { 'murano_logrotate':
  line  => "\"/var/log/murano/*.log\"",
  after => "\"/var/log/sudo.log\"",
  path  => '/etc/logrotate.d/fuel.nodaily',
}
