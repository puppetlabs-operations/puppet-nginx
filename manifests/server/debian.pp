class nginx::server::debian {

  include nginx::params

  if $lsbdistcodename == 'squeeze' {
    apt::pin{ 'nginx':
      release  => 'squeeze-backports',
      priority => '1001',
      before   => Package['nginx'],
    }
  }

  # Debian uses logrotate, other things use other things.
  file{ '/etc/logrotate.d/nginx':
    ensure  => file,
    content => template( 'nginx/debian_logrotate.erb' ),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
}
