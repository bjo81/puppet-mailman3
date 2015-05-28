#/etc/puppet/modules/mailman3/manifests/postorius.pp

class mailman3::postorius (
  $packages    = [],
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
    "${installroot}/postorius_standalone":
      ensure  => directory,
      owner   => $apache::user,
      group   => $apache::group,
      recurse => true,
      source  => 'puppet:///modules/mailman3/postorius';
  }

  python::virtualenv {
    "${installroot}/venv2":
      ensure       => present,
      requirements => "${installroot}/postorius.txt",
      owner        => $apache::group,
      group        => $apache::group,
      require      => File["${installroot}/postorius.txt"],
  }->

  exec { 'postorius collectstatic':
    command => "${installroot}/venv2/bin/python manage.py collectstatic --noinput",
    creates => "${installroot}/postorius_standalone/static/postorius",
    cwd     => "${installroot}/postorius_standalone",
    user    => $apache::user,
    require => File["${installroot}/postorius_standalone"],
  }
}
