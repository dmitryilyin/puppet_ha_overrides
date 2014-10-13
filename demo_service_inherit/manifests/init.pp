class demo_service_inherit inherits demo_service {

  file { 'nginx-ocf' :
    ensure => present,
    path   => '/usr/lib/ocf/resource.d/pacemaker/nginx',
    mode   => '0775',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/demo_service_inherit/nginx-ocf.sh',
  }

  cs_primitive { 'p_nginx':
    primitive_class => 'ocf',
    primitive_type  => 'nginx',
    provided_by     => 'pacemaker',
    operations      => {
      'monitor' => {
        'interval' => '10s',
        'timeout'  => '30s',
        'OCF_CHECK_LEVEL' => '1',
      },
      'start'   => {
        'interval' => '0',
        'timeout'  => '30s',
        'on-fail'  => 'restart',
      }
    },
  }

  Service['nginx'] {
    ensure => 'stopped',
    enable => 'false',
  }

  #service { 'nginx' :
  #  ensure   => 'running',
  #  enable   => true,
  #  provider => 'pacamaker',
  #}

  File['nginx-ocf'] ->
  Cs_primitive['p_nginx'] ->
  Service['nginx']

}
