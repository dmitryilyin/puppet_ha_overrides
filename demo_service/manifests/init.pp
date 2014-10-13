class demo_service {

  package { 'nginx' :
    ensure => 'installed',
  }

  service { 'nginx' :
    ensure => 'running',
    enable => true,
  }

  Package['nginx'] -> Service['nginx']

}
