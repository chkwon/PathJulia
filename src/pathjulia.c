// This file is a modification of "obstacle.c" in
// https://github.com/ampl/pathlib/blob/master/examples/C/obstacle.c
// This modification enables a user provide function pointers to
// both funcEval and jacEval.
// The main purpose is to provide those function from Julia.

// Changhyun Kwon https://github.com/chkwon/



#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>
#include "Standalone_Path.h"
#include "Types.h"

static int fill_structure;      /* Do we need to fill in the structure of    */
                                /* the Jacobian?                             */

static int (*f_eval)(int n, double *z, double *f);
static int (*j_eval)(int n, int nnz, double *z, int *col_start, int *col_len,
            int *row, double *data);

int funcEval(int n, double *z, double *f)
{
  f_eval(n, z, f);
  return 0;
}

int jacEval(int n, int nnz, double *z, int *col_start, int *col_len,
            int *row, double *data)
{
  j_eval(n, nnz, z, col_start, col_len, row, data);
  return 0;
} /* jacEval */

#define MIN(A,B) ((A) < (B)) ? (A) : (B)

double resid (int n, const double z[], const double f[],
              const double lb[], const double ub[])
{
  double loTmp, upTmp, t, r;
  int i;

  r = 0;
  for (i = 0;  i < n;  i++) {
    assert(z[i] >= lb[i]);
    assert(z[i] <= ub[i]);
    if (f[i] > 0) {
      t = MIN(f[i],z[i]-lb[i]);
      r += t;
    }
    else {
      t = MIN(-f[i], ub[i]-z[i]);
      r += t;
    }
  }
  return r;
} /* resid */

int path_solver (int n, int nnz,
                 double *z, double *f,
                 double *lb, double *ub,
                 void *f_eval_user, void *j_eval_user)
{
  f_eval = f_eval_user;
  j_eval = j_eval_user;

  int i;

  // double *lb;          /* Lower bounds on the variables             */
  // double *ub;          /* Upper bounds on the variables             */
  // double *z;           /* Solution vector                           */
  // double *f;           /* Function evaluation                       */
  double r;

  // int n;               /* Number of variable (N*N)                  */
  // int nnz;             /* Number of nonzeros (5*N*N - 4*N)          */
  int status;          /* Termination status from PATH              */

  /************************************************************************/
  /* Allocate space for the bounds, starting point, and function value.   */
  /************************************************************************/

  // lb = (double *)malloc(sizeof(double)*n);
  // ub = (double *)malloc(sizeof(double)*n);
  // z = (double *)malloc(sizeof(double)*n);
  // f = (double *)malloc(sizeof(double)*n);

  /************************************************************************/
  /* Fill in the lower and upper bounds and a starting point.             */
  /************************************************************************/

  // for (i = 0; i < n; i++) {
  //     lb[i] = 0.0;
  //     ub[i] = 100.0;
  //     z[i] = 1.0;
  // }

  /************************************************************************/
  /* Call PATH.                                                           */
  /************************************************************************/

  pathMain (n, nnz, &status, z, f, lb, ub);

  if (MCP_Solved != status)
    return EXIT_FAILURE;
  (void) funcEval (n, z, f);
  r = resid (n, z, f, lb, ub);
  if (r > 1e-6) {
    printf ("Residual of %g is too large: failure\n", r);
    return EXIT_FAILURE;
  }
  else
    printf ("Residual of %g is OK\n", r);

  /************************************************************************/
  /* Deallocate memory.                                                   */
  /************************************************************************/
  // for (i=0; i<n; i++) {
  //     printf("z[%d] = %f\n", i, z[i]);
  // }

  // free(lb);
  // free(ub);
  // free(z);
  // free(f);

  return status;
} /* main */
