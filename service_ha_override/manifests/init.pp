define service_ha_override (
  $ocf_script_source = 'demo_service_inherit/nginx-ocf.sh',
  $ocf_type = 'nginx',
  $ocf_provider = 'pacemaker',
  $ocf_parameters = '.....',
) {
  $service = $title
  $pcmk_service = "p_${title}"

  if $ocf_script_source {
    file { "${service}-ocf" :
      ensure => present,
      path   => "/usr/lib/ocf/resource.d/${ocf_provider}/${ocf_type}",
      mode   => '0775',
      owner  => 'root',
      group  => 'root',
      source => "puppet:///modules/${ocf_script_source}",
    }
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

  Service <| title == $service |> {
    ensure => 'stopped',
    enable => 'false',
  }

  #service { $pcmk_service :
  #  ensure   => 'running',
  #  enable   => true,
  #  provider => 'pacamaker',
  #}

  File <| title == 'nginx-ocf' |> -> Cs_primitive['p_nginx']
  Cs_primitive['p_nginx'] -> Service['nginx']
  Service <| title == $pcmk_service |> -> Service['nginx']

}
