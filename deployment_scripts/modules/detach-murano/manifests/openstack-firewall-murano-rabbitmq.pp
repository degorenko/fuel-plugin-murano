$murano_rabbitmq_port = 55572

firewall { '203 murano-rabbitmq' :
  dport  => $murano_rabbitmq_port,
  proto  => 'tcp',
  action => 'accept',
}
