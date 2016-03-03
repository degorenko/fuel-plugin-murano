notice('MURANO PLUGIN: update_glance.pp')

$murano_hash     = hiera_hash('murano_hash', {})
$murano_plugins  = $murano_hash['plugins']

if $murano_plugins['glance_artifacts_plugin']['enabled'] {

  include ::glance::params

  package {'murano-glance-artifacts-plugin':
    ensure  => installed,
  }

  glance_api_config {
    'DEFAULT/enable_v3_api': value => true,
  }

  if !defined(Service[$::glance::params::api_service_name]) {
    service { $::glance::params::api_service_name:
      ensure  => 'running',
      enable  => true,
      restart => true,
      tag     => 'glance-service',
    }
  }

  if !defined(Service[$::glance::params::registry_service_name]) {
    service { $::glance::params::registry_service_name:
      ensure  => 'running',
      enable  => true,
      restart => true,
      tag     => 'glance-service',
    }
  }

  Glance_Api_Config <||> ~> Service<| tag == 'glance-service' |>

}
