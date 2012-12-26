# Class: nginx
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
class nginx {

  include nginx::params

  if ! $nginx::params::package {
    fail( "No nginx possible on ${hostname}" )
  }

  # We should monitor the state of nignx, though I am not sure this should be here
  if defined(Class['munin'])  { include metrics::munin::nginx }

}
