#ifndef PATHJULIA_H
#define PATHJULIA_H

#ifdef __cplusplus
extern "C" {
#endif


__declspec(dllexport) int path_solver (int n, int nnz,
                 double *z, double *f,
                 double *lb, double *ub,
                 void *f_eval_user, void *j_eval_user);

#endif  /* #ifndef PATHJULIA_H */

#ifdef __cplusplus
}
#endif