#/etc/puppet/modules/mailman3/manifests/postorius.pp

class mailman3::postorius (
  $packages  = [],
  $installroot = '/var/www/postorius',
) inherits ::mailman3::params {

  include mailman3

  require apache

  package { $packages:
    ensure => present,
  }

  file {
    $installroot:
      ensure => directory,
      owner  => $apache::user,
      group  => $apache::group,
      mode   => '0755';
    "${installroot}/postorius.txt":
      ensure => present,
      owner  => $apache::user,
      group  => $apache::group,
      mode   => '0644',
      source => 'puppet:///modules/mailman3/requirements/postorius.txt';
  }

  python::virtualenv {
    "${installroot}/venv2":
      ensure       => present,
      requirements => "${installroot}/postorius.txt",
      owner        => $apache::group,
      group        => $apache::group,
      require      => File["${installroot}/postorius.txt"],
  }
}
