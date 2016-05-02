#ifndef PATHJULIA_H
#define PATHJULIA_H


//
// #include <stdio.h>
// #include <stdlib.h>
// #include <assert.h>
// #include <math.h>
// #include "Standalone_Path.h"
// #include "Types.h"

int path_solver (int n, int nnz,
                 double *z, double *f,
                 double *lb, double *ub,
                 void *f_eval_user, void *j_eval_user);

#endif  /* #ifndef PATHJULIA_H */
