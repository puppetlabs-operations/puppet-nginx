# Class: nginx::params
#
#   class description goes here.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nginx::params {

  case $operatingsystem {
    'debian',
    'ubuntu': {
        $package     = 'nginx'
        $service     = 'nginx'
        $restart     = '/usr/sbin/nginx -t && /etc/init.d/nginx reload'
        $hasrestart  = true
        $hasstatus   = true
        $etcdir      = '/etc/nginx'
        $vdir        = "${etcdir}/sites-enabled"
        $confd       = "${etcdir}/conf.d"
        $threadcount = $processorcount
      }
    'freebsd': {
        $package    = 'nginx'
        $service    = 'nginx'
        $restart    = '/usr/sbin/service nginx reload'
        $hasrestart = true
        $hasstatus  = true
        $etcdir     = '/usr/local/etc/nginx'
        $vdir       = "${etcdir}/sites-enabled"
        $confd      = "${etcdir}/conf.d"
        $threadcount = '4'
      }
    default: {
        warning( "Sorry, nginx module isn't built for ${operatingsystem} yet." )
    }
  }
}
