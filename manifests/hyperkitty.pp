#/etc/puppet/modules/mailman3/manifests/hyperkitty.pp

class mailman3::hyperkitty (
  $packages    = [],
  $installroot = '/var/www/hyperkitty',
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
    "${installroot}/hyperkitty.txt":
      ensure => present,
      owner  => $apache::user,
      group  => $apache::group,
      mode   => '0644',
      source => 'puppet:///modules/mailman3/requirements/hyperkitty.txt',
  }

  python::virtualenv {
    "${installroot}/venv2":
      ensure       => present,
      requirements => "${installroot}/hyperkitty.txt",
      owner        => $apache::user,
      group        => $apache::group,
      require      => File["${installroot}/hyperkitty.txt"],
  }
}
