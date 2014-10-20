exec { "apt-get update":
  command => "/usr/bin/apt-get update -y",
} ->

package { ["git", "build-essential", "openmpi-bin", "libopenmpi-dev"]:
  ensure => "installed"
}

host { "worker1":
  ip => "192.168.0.3",
}

host { "worker2":
  ip => "192.168.0.4",
}

file { "/home/vagrant/hostfile" :
  ensure => present,
  owner => "vagrant",
  mode => "0744",
  content => "worker1
  worker2",
}

file { "/home/vagrant/.ssh/config":
  ensure => present,
  owner => "vagrant",
  mode => "0744",
  content => "Host worker1
    IdentityFile ~/.ssh/mpi_stuff
  Host worker2
    IdentityFile ~/.ssh/mpi_stuff"
}

file { "/home/vagrant/.ssh/mpi_stuff":
  ensure => present,
  owner => "vagrant",
  mode => "0600",
  content => "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAxfe6pv+WbsKPywBIsmAPyvoO/HstNQk0qVHxWJtB1jp5Llhr
/H8g9FQM90mgfi38QZVWwARMFN3szAY5ApjdiYWmw0WkVNntW0+/Wvapv8f4g0eT
HMe/COeGBR3R2UC9L8aI8knFl5fEF5DfBBhdboszZk+IUcbGXRtr49ACt/sDcABh
37tV+yE14TfReNKSUUDfFOMjMyKrrPwgNczYU35uk1c9bdXP1PuGJTa7cr5lDwf0
k8tFzC0o+tgJFx8F3wVOJjBZBtQANEUzfJRBTzugwPNL+rKkS2V7VCSAxRy1d0QU
x5ebExmgw/fwTEN+7CnG5u1OEC7UGVJAGbMX5wIDAQABAoIBAQCOuNrIKtu5Xmts
XvgKIVdBbqX/QI6G/ewJZhopV0VPvThAQV8Y2k5X14DBh0M9tMl4PsIcDP0MzjI5
pQLU7IBK9SAVB9BBnBuTCRtb6RjYOsLfYmqdBSSktsXYSndPuWyrVObGRok9kRy+
IKOnwCkb2R9lU1FkI3o/BdXyl7ReDkQva3twPiyNd5lkf4EvcFGyf/mSydiujWRJ
dqXvjh/oJf7YlofnQVEUxDgMgB59wpwjX6oDk2A/uRs0qjMb+I47ex0S0OmgVueM
9DMzcqdhld/fD3YHl7XMcoZZS92kYRU61LSLVOkV9I9c4g+WwRsnlTY2HZwpz3R/
Gautov0BAoGBAPG8UJvjEH8F25+0wNtSzrothANuzlbVCHPc4MdI1P2tST3ySE5Z
JnO9GsHLA5k5Y46CWZ9xq0wpE3mJyU5fgu+8aPZokI62Uep0UOmd4DssK54dox4y
Omc3+Yk9Cw27zVhdesDO0CZwi2YWpaHFQnjuk0Wi4ibmmfBgBmwP22Y/AoGBANGm
QFDj0k06mj8+RmIr/ROCDIx8BHArRK502R5J4STSvDeoqHY+rjAFYk0lyze8KpV/
nQIm6DY3ub7MUHxwdaB5FARw//NQEmIw2YACvDN0IktYalUEICyU+vizkMk01ge7
U1gh/jh/t+YlHxdYA3C/V2fNxpFRvlZWelK96HRZAoGBALuRx2puEcq+HOAbPNnx
sv67eoe/XtP5kQl2BeQcG0iLQR2T9Y71leSQg0aD5FLsONfHRQt3A9egt7/CrjTl
349tvnQURra1uXIWtwHOwsKnT2Ds1jkD+FVHFZTrjLwnUPqT7j/VOaXaBhA82mBf
02hKlnOeI6TTofbmS5Vl6HO5AoGBAL3CJB7TRsu+SlUKEfzT4fqhUKhrrDy2/TCG
9OqUZmPFFrWuQ+TbMSCoDuTTW5A0EbtFSaDkBHTmlYpcNlGcHOvGC9dFTHY3uJwF
qShT0XMlH9Fg0sXmuRSBOHSZW2izGTLgXDy+b/NFrvdyDCU99cc8eWmseJmaCpTt
K0TvPZLpAoGAJjfa0iNHR9hoDy5LQTLhQMKSCKY1z0v3Rgrv9nGd96xFstnAGJmz
R9V+OE6EZznlmw7bQmM/p1OcqvAhMCwAUkC0+ev69Tyb0VYbbII+isyx//SuYqIV
17y29aFTbtqj33gjxv85+aBWxgBBWYzDplfkFIVaxDVo2piQJ6jPMJ4=
-----END RSA PRIVATE KEY-----",
}

ssh_authorized_key { "mpi_stuff keys":
  user => "vagrant",
  type => "ssh-rsa",
  key  => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDF97qm/5Zuwo/LAEiyYA/K+g78ey01CTSpUfFYm0HWOnkuWGv8fyD0VAz3SaB+LfxBlVbABEwU3ezMBjkCmN2JhabDRaRU2e1bT79a9qm/x/iDR5Mcx78I54YFHdHZQL0vxojyScWXl8QXkN8EGF1uizNmT4hRxsZdG2vj0AK3+wNwAGHfu1X7ITXhN9F40pJRQN8U4yMzIqus/CA1zNhTfm6TVz1t1c/U+4YlNrtyvmUPB/STy0XMLSj62AkXHwXfBU4mMFkG1AA0RTN8lEFPO6DA80v6sqRLZXtUJIDFHLV3RBTHl5sTGaDD9/BMQ37sKcbm7U4QLtQZUkAZsxfn",
}
