include demo_service
demo_service::definition { "test" :}

$ha_mode = true

if $ha_mode {

  class { 'corosync':
    enable_secauth    => false,
    bind_address      => '127.0.0.0',
    multicast_address => '239.1.1.2',
  }

  corosync::service { 'pacemaker':
    version => '0',
  }

  cs_property { 'stonith-enabled' :
    value   => 'false',
  }

  cs_property { 'no-quorum-policy' :
    value   => 'ignore',
  }

  Service['corosync'] ->
  Cs_property<||> ->
  Cs_primitive<||>

  include demo_service_ha
  demo_service_ha::definition { 'test' :}

}
