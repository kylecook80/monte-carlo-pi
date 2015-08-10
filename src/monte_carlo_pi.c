#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>

typedef struct {
  double x, y;
} Point;

double distance(double x1, double y1, double x2, double y2);
Point generate_random_point();

double distance(double x1, double y1, double x2, double y2) {
  return sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
}

Point generate_random_point(void) {
  double x = ((double)rand() / (double)RAND_MAX) * 2.0;
  double y = ((double)rand() / (double)RAND_MAX) * 2.0;
  Point p = {x, y};
  return p;
}

int main(int argc, char *argv[]) {
  long total_iter = atol(argv[1]);
  long seed = atoi(argv[2]);

  MPI_Init(NULL, NULL);

  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);

  int my_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

  double start_time, end_time, actual_time;

  double global_ratio;
  double global_pi;
  long global_within_circle = 0;
  long within_circle = 0;

  long iter = total_iter / (world_size - 1);

  if(my_rank == 0) {
    printf("total processes: %d\n", world_size);
    start_time = MPI_Wtime();
  } else {
    srand(seed + my_rank);

    long i;
    for(i=0; i<iter; i++) {
      Point p = generate_random_point();
      if(distance(p.x, p.y, (double)1, (double)1) <= (double)1) {
        within_circle++;
      }
    }
  }

  MPI_Reduce(&within_circle, &global_within_circle, 1, MPI_LONG, MPI_SUM, 0, MPI_COMM_WORLD);
  // MPI_Barrier(MPI_COMM_WORLD);

  if(my_rank == 0) {
    global_ratio = (double)global_within_circle / (double)total_iter;
    global_pi = global_ratio * 4.0;

    end_time = MPI_Wtime();
    actual_time = end_time - start_time;

    printf("PI is approximately: %0.12f\n", global_pi);
    printf("Average time to compute PI: %0.02f seconds\n", actual_time);
  }

  MPI_Finalize();
}
