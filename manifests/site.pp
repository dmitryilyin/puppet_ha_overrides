include demo_service
$ha = true

demo_service::demo_def { "test" :}

if $ha {

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

  # individual inherit method
  include demo_service_inherit
  demo_service_inherit::demo_def { 'test' :}
  # ha override definition method
  # service_ha_override { 'nginx' :}
  # service_ha_override::demo_def { 'test' :}

}
