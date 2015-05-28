#/etc/puppet/modules/mailman3/manifests/core.pp

class mailman3::core (
  $packages  = ['python3-dev'],
  $username  = 'mailman',
  $groupname = 'mailman',
) {

  include mailman3

  package { $packages:
    ensure => present,
  }

  file { "/home/${username}/mailman.txt":
    ensure => present,
    owner  => $username,
    group  => $groupname,
    mode   => '0644',
    source => 'puppet:///modules/mailman3/requirements/mailman.txt',
  }

  # Because pyvenv in ubuntu 14.04 broke, manually create it for now
  exec { 'create python3 venv':
    command => 'virtualenv -p python3 venv3',
    cwd     => "/home/${username}",
    creates => "/home/${username}/venv3",
    user    => $username,
    group   => $groupname,
    path    => [ '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
    require => [ Class['python'], Package['python-virtualenv'] ],
  }

  # Once pyvenv in ubuntu 14.04 is fixed, comment out the above exec,
  # and uncomment the below pyvenv block
  #python::pyvenv { '/opt/venv3':
  #  ensure => present,
  #  owner  => $username,
  #  group  => $username,
  #}

  python::requirements { 'mailman3.txt':
    requirements => "/home/${username}/mailman.txt",
    cwd          => "/home/${username}",
    virtualenv   => "/home/${username}/venv3",
    owner        => $username,
    group        => $username,
    require      => [ Package['python3-dev'], Exec['create python3 venv'], File["/home/${username}/mailman.txt"] ],
  }

}
