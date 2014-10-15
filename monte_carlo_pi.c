#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct {
  float x, y;
} Point;

float distance(float x1, float y1, float x2, float y2);
Point generate_random_point();

int x_max = 2;
int y_max = 2;

int main(int argc, char *argv[]) {
  int total_iter = atoi(argv[1]);
  int seed = atoi(argv[2]);

  MPI_Init(NULL, NULL);

  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);

  int my_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

  srand(seed + my_rank);

  int iter = total_iter / world_size;
  int global_within_circle;
  int within_circle;
  int i;

  for(i=0; i<iter; i++) {
    Point p = generate_random_point();
    if(distance(p.x, p.y, 1, 1) < 1) {
      within_circle++;
    }
  }

  MPI_Reduce(&within_circle, &global_within_circle, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

  float ratio = (float)within_circle / (float)iter;
  float pi = ratio * 4.0;
  printf("Local PI: %f\n", pi);

  if(my_rank == 0) {
    float global_ratio = (float)global_within_circle / (float)total_iter;
    float global_pi = global_ratio * 4.0;
    printf("Global PI: %f\n", global_pi);
  }

  MPI_Finalize();
}

Point generate_random_point() {
  float x = ((float)rand() / (float)RAND_MAX) * 2.0;
  float y = ((float)rand() / (float)RAND_MAX) * 2.0;
  Point p = {x, y};
  return p;
}

float distance(float x1, float y1, float x2, float y2) {
  return sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
}
