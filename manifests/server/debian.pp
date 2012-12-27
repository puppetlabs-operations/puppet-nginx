class nginx::server::debian {

  include nginx::params

  if $lsbdistcodename == 'squeeze' {
    apt::pin{ 'nginx':
      release  => 'squeeze-backports',
      priority => '1001',
      before   => Package['nginx'],
    }
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
