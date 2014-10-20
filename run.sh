#mpirun -n $1 --hostfile hostfile --mca btl_tcp_if_include eth1 ./pi $2 $3
mpirun -n $1 ./pi $2 $3
