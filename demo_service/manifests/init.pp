class demo_service (
  $package = $::demo_service::defaults::package,
  $service = $::demo_service::defaults::service,
) inherits demo_service::defaults {

  package { 'nginx' :
    ensure => 'installed',
    name   => $package,
  }

  service { 'nginx' :
    ensure => 'running',
    enable => true,
    name   => $service,
  }

  Package['nginx'] -> Service['nginx']

}
