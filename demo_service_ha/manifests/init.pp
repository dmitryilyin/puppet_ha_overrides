class demo_service_ha (
  $ocf_script_source = 'demo_service_inherit/nginx-ocf.sh',
  $ocf_type = 'nginx',
  $ocf_provider = 'pacemaker',
) inherits demo_service {
  $pcmk_service = "p_${service}"

  file { 'nginx-ocf' :
    ensure => present,
    path   => "/usr/lib/ocf/resource.d/${ocf_provider}/${ocf_type}",
    mode   => '0775',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/${ocf_script_source}",
  }

  cs_primitive { $pcmk_service :
    primitive_class => 'ocf',
    primitive_type  => $ocf_type,
    provided_by     => $ocf_provider,
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
    provider => 'pacemaker',
    name     => $pcmk_service,
  }

  service { 'nginx_stopped' :
    name   => $service,
    ensure => 'stopped',
    enable => false,
  }

  File['nginx-ocf'] ->
  Cs_primitive[$pcmk_service] ->
  Service['nginx_stopped'] ->
  Service['nginx']

}
