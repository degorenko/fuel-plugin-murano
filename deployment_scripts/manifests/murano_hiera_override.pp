notice('MODULAR: detach-murano/murano_hiera_override.pp')

$detach_murano_plugin = hiera('detach-murano', undef)
$hiera_dir = '/etc/hiera/plugins'
$plugin_name = 'detach-murano'
$plugin_yaml = "${plugin_name}.yaml"

if $detach_murano_plugin {
  $network_metadata   = hiera_hash('network_metadata')
  $nodes_hash         = hiera('nodes')
  $murano_nodes       = get_nodes_hash_by_roles($network_metadata, ['murano'])
  $murano_address_map = get_node_to_ipaddr_map_by_network_role($murano_nodes, 'management')
  $murano_nodes_ips   = values($murano_address_map)
  $murano_nodes_names = keys($murano_address_map)

  # hardcode for now
  $murano_db_password           = 'change_me'
  $murano_cfapi_db_password     = 'change_me'
  $murano_rabbit_password       = 'change_me'
  $murano_cfapi_rabbit_password = 'change_me'
  $murano_user_password         = 'change_me'
  $murano_cfapi_user_password   = 'change_me'

  ###################
  $calculated_content = inline_template('
murano_ipaddresses:
<%
@murano_nodes_ips.each do |muranoip|
%>  - <%= muranoip %>
<% end -%>
murano_names:
@murano_nodes_names.each do |muranoname|
%>  - <%= muranoname %>
<% end -%>
murano_db_password: @murano_db_password
murano_cfapi_db_password: @murano_cfapi_db_password
murano_rabbit_password: @murano_rabbit_password
murano_cfapi_rabbit_password: @murano_cfapi_rabbit_password
murano_user_password: @murano_user_password
murano_cfapi_user_password: @murano_cfapi_user_password
')

  ###################
  file {'/etc/hiera/override':
    ensure  => directory,
  } ->
  file { "${hiera_dir}/${plugin_yaml}":
    ensure  => file,
    content => "${detach_murano_plugin['yaml_additional_config']}\n${calculated_content}\n",
  }

  package {'ruby-deep-merge':
    ensure  => 'installed',
  }
}
