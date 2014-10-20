#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct {
  double x, y;
} Point;

double distance(double x1, double y1, double x2, double y2);
Point generate_random_point();

double distance(double x1, double y1, double x2, double y2) {
  return sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
}

Point generate_random_point() {
  double x = ((double)rand() / (double)RAND_MAX) * 2.0;
  double y = ((double)rand() / (double)RAND_MAX) * 2.0;
  Point p = {x, y};
  return p;
}

int main(int argc, char *argv[]) {
  int total_iter = atoi(argv[1]);
  int seed = atoi(argv[2]);

  MPI_Init(NULL, NULL);

  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);

  int my_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

  if(my_rank == 0) {
    printf("total processes: %d\n", world_size);
  }

  srand(seed + my_rank);

  int iter = total_iter / world_size;
  int global_within_circle;
  int within_circle;
  int i;

  for(i=0; i<iter; i++) {
    Point p = generate_random_point();
    if(distance(p.x, p.y, (double)1, (double)1) <= (double)1) {
      within_circle++;
    }
  }

  MPI_Reduce(&within_circle, &global_within_circle, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

  double ratio = (double)within_circle / (double)iter;
  double pi = ratio * 4.0;
  printf("Local PI for %d: %f\n", my_rank, pi);

  if(my_rank == 0) {
    double global_ratio = (double)global_within_circle / (double)total_iter;
    double global_pi = global_ratio * 4.0;
    printf("Global PI: %f\n", global_pi);
  }

  MPI_Finalize();
}
