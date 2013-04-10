class splunk::service ($ensure = "${splunk::ensure}",) {
  # input validation


  # setting the correct variables
  $manage_service = $ensure ? {
    'absent' => "absent",
    default  => "running",
  }

  # flow control

  service { "splunk": ensure => $manage_service, hasrestart => true }

}