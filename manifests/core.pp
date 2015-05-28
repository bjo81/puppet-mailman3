#/etc/puppet/modules/mailman3/manifests/core.pp

class mailman3::core (
  $packages    = ['python3-dev'],
  $username    = 'mailman',
  $groupname   = 'mailman',
  $installroot = '/usr/local/mailman3-core',
  $gid         = '9999',
  $uid         = '9999',
) inherits ::mailman3::params {

  include mailman3

  package { $packages:
    ensure => present,
  }

  group { $groupname:
    ensure => present,
    gid    => $gid,
  }->

  user { $username:
    ensure  => present,
    uid     => $uid,
    gid     => $groupname,
    home    => "/home/${username}",
    require => Group[$groupname],
  }->

  file {
    $installroot:
      ensure  => directory,
      owner   => $username,
      group   => $groupname,
      mode    => '0755',
      require => User[$username];
    "${installroot}/mailman.txt":
      ensure  => present,
      owner   => $username,
      group   => $groupname,
      mode    => '0644',
      source  => 'puppet:///modules/mailman3/requirements/mailman.txt';
    '/etc/mailman':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755';
    '/etc/mailman/mailman.cfg':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/mailman3/mailman3/mailman.cfg';
  }


  # Because pyvenv in ubuntu 14.04 broke, manually create it for now

  case $operatingsystem {
    'Ubuntu': {
      case $operatingsystemrelease {
        '14.04':
          exec { 'create python3 venv':
            command => 'virtualenv -p python3 venv3',
            cwd     => $installroot,
            creates => "${installroot}/venv3/bin/activate",
            user    => $username,
            group   => $groupname,
            path    => [ '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
            require => [ Package['python-virtualenv'], User[$username] ],
          }
        }
      }
    default: {
      python::pyvenv { '/opt/venv3':
        ensure => present,
        owner  => $username,
        group  => $username,
      }
    }
  }

  python::requirements {
    'mailman3.txt':
      requirements => "${installroot}/mailman.txt",
      cwd          => $installroot,
      virtualenv   => "${installroot}/venv3",
      owner        => $username,
      group        => $groupname,
      require      => [ Package['python3-dev'], Exec['create python3 venv'], File["${installroot}/mailman.txt"] ],
  }


}
