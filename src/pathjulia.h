#ifndef PATHJULIA_H
#define PATHJULIA_H


int path_main( int n, int nnz,
                double *z, double *f, double *lb, double *ub,
                char **var_name, char **con_name,
                void *f_eval, void *j_eval);

#endif  /* #ifndef PATHJULIA_H */
