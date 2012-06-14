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

    # Pull in package xz if we haven't already.
    # See dist/packages/manifests/archive.pp
    Package <| alias == 'xz' |>

    # Debian uses logrotate, other things use other things.
    file{ '/etc/logrotate.d/nginx':
      ensure  => file,
      content => template( 'nginx/debian_logrotate.erb' ),
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      require => Package['xz'],
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
