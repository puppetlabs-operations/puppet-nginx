# Class: nginx::server
#
#   Install and run the nginx webserver.
#
# Requires:
#
# Debian/ubuntu at present.
#
class nginx::server {
  include nginx

  # We assume for our modules, we have the motd module, & use it.
  motd::register{ 'nginx': }

  package{ 'nginx':
    ensure => present,
    name   => $nginx::params::package,
  }

  if $operatingsystem == 'Debian' {
    apt::pin{
      'nginx':
        release  => 'squeeze-backports',
        priority => '1001'
    }
  }

  service{ 'nginx':
    ensure     => running,
    name       => $nginx::params::service,
    enable     => true,
    hasstatus  => $nginx::params::hasstatus,
    hasrestart => $nginx::params::hasrestart,
    restart    => $nginx::params::restart,
    subscribe  => Package['nginx'],
  }


  # All the files, stolen from debian, hence this being debian
  # specific at the minute.
  file {
    $nginx::params::vdir:
      ensure  => directory,
      recurse => true,
      purge   => true,
      notify  => Service['nginx'],
      require => Package['nginx'];
    "${nginx::params::etcdir}/nginx.conf":
      content => template( 'nginx/nginx.conf.erb' ),
      owner   => 'root',
      mode    => '0644',
      notify  => Service['nginx'],
      require => Package['nginx'];
  }

}
