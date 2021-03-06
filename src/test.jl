
Libdl.dlopen("./libpath47julia")

########################################################################
###############################################################################
# wrappers for callback functions
###############################################################################
# static int (*f_eval)(int n, double *z, double *f);
# static int (*j_eval)(int n, int nnz, double *z, int *col_start, int *col_len,
            # int *row, double *data);

function f_user_wrap(n::Cint, z::Ptr{Cdouble}, f::Ptr{Cdouble})
    F = user_f(unsafe_wrap(Array{Float64}, z, Int(n), false))
    unsafe_store_vector!(f, F)
    return Cint(0)
end

function j_user_wrap(n::Cint, nnz::Cint, z::Ptr{Cdouble},
    col_start::Ptr{Cint}, col_len::Ptr{Cint}, row::Ptr{Cint}, data::Ptr{Cdouble})

    J = user_j(unsafe_wrap(Array{Float64}, z, Int(n), false))

    s_col, s_len, s_row, s_data = sparse_matrix(J)

    unsafe_store_vector!(col_start, s_col)
    unsafe_store_vector!(col_len, s_len)
    unsafe_store_vector!(row, s_row)
    unsafe_store_vector!(data, s_data)

    return Cint(0)
end
###############################################################################




###############################################################################
# Converting the Jacobian matrix to the sparse matrix format of the PATH Solver
###############################################################################
function sparse_matrix(A::AbstractSparseArray)
    m, n = size(A)
    @assert m==n

    col_start = Array{Int}(n)
    col_len = Array{Int}(n)
    row = Array{Int}(0)
    data = Array{Float64}(0)
    for j in 1:n
        if j==1
            col_start[j] = 1
        else
            col_start[j] = col_start[j-1] + col_len[j-1]
        end

        col_len[j] = 0
        for i in 1:n
            if A[i,j] != 0.0
                col_len[j] += 1
                push!(row, i)
                push!(data, A[i,j])
            end
        end
    end

    return col_start, col_len, row, data
end

function sparse_matrix(A::Matrix)
    return sparse_matrix(sparse(A))
    # m, n = size(A)
    # @assert m==n
    #
    # col_start = Array{Int}(n)
    # col_len = Array{Int}(n)
    # row = Array{Int}(0)
    # data = Array{Float64}(0)
    # for j in 1:n
    #     if j==1
    #         col_start[j] = 1
    #     else
    #         col_start[j] = col_start[j-1] + col_len[j-1]
    #     end
    #
    #     col_len[j] = 0
    #     for i in 1:n
    #         if A[i,j] != 0.0
    #             col_len[j] += 1
    #             push!(row, i)
    #             push!(data, A[i,j])
    #         end
    #     end
    # end
    #
    # return col_start, col_len, row, data
end
###############################################################################






function unsafe_store_vector!(x_ptr::Ptr{Cint}, x_val::Vector)
    for i in 1:length(x_val)
        unsafe_store!(x_ptr, x_val[i], i)
    end
    return
end

function unsafe_store_vector!(x_ptr::Ptr{Cdouble}, x_val::Vector)
    for i in 1:length(x_val)
        unsafe_store!(x_ptr, x_val[i], i)
    end
    return
end







###############################################################################


function solveMCP(f_eval::Function, lb::Vector, ub::Vector)
    var_name = C_NULL
    con_name = C_NULL
    return solveMCP(f_eval, lb, ub, var_name, con_name)
end

function solveMCP(f_eval::Function, lb::Vector, ub::Vector, var_name, con_name)
    j_eval = x -> ForwardDiff.jacobian(f_eval, x)
    return solveMCP(f_eval, j_eval, lb, ub, var_name, con_name)
end


function solveMCP(f_eval::Function, j_eval::Function, lb::Vector, ub::Vector, var_name, con_name)
  global user_f = f_eval
  global user_j = j_eval

  f_user_cb = cfunction(f_user_wrap, Cint, (Cint, Ptr{Cdouble}, Ptr{Cdouble}))
  j_user_cb = cfunction(j_user_wrap, Cint, (Cint, Cint, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}))

  n = length(lb)
  z = copy(lb)
  f = zeros(n)

  J0 = j_eval(z)
  s_col, s_len, s_row, s_data = sparse_matrix(J0)
  nnz = length(s_data)

  t = ccall( (:path_main, "libpath47julia"), Cint,
                  (Cint, Cint,
                   Ptr{Cdouble}, Ptr{Cdouble},
                   Ptr{Cdouble}, Ptr{Cdouble},
                   Ptr{Ptr{Cchar}}, Ptr{Ptr{Cchar}},
                   Ptr{Void}, Ptr{Void}),
                   n, nnz, z, f, lb, ub, var_name, con_name, f_user_cb, j_user_cb)

  status =
   [ :Solved,                          # 1 - solved
     :StationaryPointFound,            # 2 - stationary point found
     :MajorIterationLimit,             # 3 - major iteration limit
     :CumulativeMinorIterationLimit,   # 4 - cumulative minor iteration limit
     :TimeLimit,                       # 5 - time limit
     :UserInterrupt,                   # 6 - user interrupt
     :BoundError,                      # 7 - bound error (lb is not less than ub)
     :DomainError,                     # 8 - domain error (could not find a starting point)
     :InternalError                    # 9 - internal error
    ]

  return status[t], z, f

end









using ForwardDiff


M = [0  0 -1 -1 ;
     0  0  1 -2 ;
     1 -1  2 -2 ;
     1  2 -2  4 ]

q = [2; 2; -2; -6]

myfunc(x) = M*x + q

n = 4
lb = zeros(n)
ub = 100*ones(n)

var_name = ["x[1]", "x[2]", "x[3]", "x[4]"]
con_name = ["FF[1]", "FF[2]", "FF[3]", "FF[4]"]
status, z, f = solveMCP(myfunc, lb, ub)
status, z, f = solveMCP(myfunc, lb, ub, var_name, con_name)

@show status
@show z
@show f

using Base.Test

@test isapprox(z, [2.8, 0.0, 0.8, 1.2])
@test status == :Solved
