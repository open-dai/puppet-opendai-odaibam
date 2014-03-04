# Class: odaibam
#
# This module manages odaibam
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class odaibam ($repo_server) {
  $bam = hiera('bam', undef)
  $greg = hiera('greg', undef)

  package { 'unzip': ensure => present, }

  if !defined(Package['mysql']) {
    package { 'mysql': ensure => present, }
  }

  # REQUIREMENTS
  # Java
  class { 'opendai_java':
    distribution => 'jdk',
    version      => '6u25',
    repos        => $repo_server,
  }

  class { 'wso2bam':
    download_site   => "http://${repo_server}/",
    db_type         => $bam["db_type"],
    db_host         => $bam["db_host"],
    db_name         => $bam["db_name"],
    db_user         => $bam["db_user"],
    db_password     => $bam["db_password"],
    db_tag          => $bam["db_tag"],
    version         => "2.4.0",
    admin_password  => $bam["admin_password"],
    external_greg   => $bam["external_greg"],
    greg_server_url => $greg["server_url"],
    greg_db_host    => $greg["db_host"],
    greg_db_name    => $greg["db_name"],
    greg_db_type    => $greg["db_type"],
    greg_username   => $greg["db_name"],
    greg_password   => $greg["db_password"],
    used_by_api=>$bam["used_by_api"],
    db_api_name=>$bam["db_api_name"],
    require         => [Class['opendai_java'], Package['unzip'], Package['mysql']]
  }

  Wso2bam::Add_analitics <<| tag == $bam['analitics_tag'] |>>
}
