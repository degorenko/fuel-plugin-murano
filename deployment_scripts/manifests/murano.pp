$murano = merge({'rabbit' => {'vhost' => '/', 'port' => '55572'}}, hiera('detach-murano', {})
$syslog_log_facility_murano = 'LOG_LOCAL0'
$murano_glare_plugin = $murano['murano_glance_artifacts']
$murano_cfapi = $murano['murano_cfapi']
