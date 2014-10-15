exec { "apt-get update":
  command => "/usr/bin/apt-get update -y",
} ->

package { ["git", "build-essential", "openmpi-bin", "libopenmpi-dev"]:
  ensure => "installed"
} ->

host { 'worker1':
  ip => '192.168.0.3',
} ->

host { 'worker2':
  ip => '192.168.0.4',
} ->

file { "/home/vagrant/compile.sh":
  ensure => present,
  source => "puppet:///modules/mpi_stuff/compile.sh",
  owner => "vagrant",
  mode => "0754",
} ->

file { "/home/vagrant/dist.sh":
  ensure => present,
  source => "puppet:///modules/mpi_stuff/dist.sh",
  owner => "vagrant",
  mode => "0754",
} ->

file { "/home/vagrant/run.sh":
  ensure => present,
  source => "puppet:///modules/mpi_stuff/run.sh",
  owner => "vagrant",
  mode => "0754",
} ->

file { "/home/vagrant/hostfile":
  ensure => present,
  source => "puppet:///modules/mpi_stuff/hostfile",
  owner => "vagrant",
  mode => "0754",
} ->

file { "/home/vagrant/monte_carlo_pi.c":
  ensure => present,
  source => "puppet:///modules/mpi_stuff/monte_carlo_pi.c",
  owner => "vagrant",
  mode => "0754",
}

concat { "/home/vagrant/.ssh/authorized_keys":
  ensure => present
}

concat::fragment { "authorized_keys":
  target => "/home/vagrant/.ssh/authorized_keys",
  content => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDF97qm/5Zuwo/LAEiyYA/K+g78ey01CTSpUfFYm0HWOnkuWGv8fyD0VAz3SaB+LfxBlVbABEwU3ezMBjkCmN2JhabDRaRU2e1bT79a9qm/x/iDR5Mcx78I54YFHdHZQL0vxojyScWXl8QXkN8EGF1uizNmT4hRxsZdG2vj0AK3+wNwAGHfu1X7ITXhN9F40pJRQN8U4yMzIqus/CA1zNhTfm6TVz1t1c/U+4YlNrtyvmUPB/STy0XMLSj62AkXHwXfBU4mMFkG1AA0RTN8lEFPO6DA80v6sqRLZXtUJIDFHLV3RBTHl5sTGaDD9/BMQ37sKcbm7U4QLtQZUkAZsxfn kyle@Kyles-Waterfield-MacBook-Pro.local",
  order => "01",
}
