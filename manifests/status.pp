class nginx::status( $monitorport = '80' ) {

  nginx::vhost { "status":
    template => "nginx/vhost-status.conf.erb"
  }

}
