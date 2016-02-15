file { "${::rsyslog::params::rsyslog_d}53-murano.conf":
  ensure => present,
  content => template("${module_name}/53-murano.conf.erb"),
}

Murano_config <| title == 'DEFAULT/log_config' |> { ensure => absent }
