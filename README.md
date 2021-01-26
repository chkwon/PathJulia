Now the all-new [PATHSolver.jl](https://github.com/chkwon/PATHSolver.jl) can access PATH directly. 

# PathJulia

[![Build Status](https://travis-ci.org/chkwon/PathJulia.svg?branch=master)](https://travis-ci.org/chkwon/PathJulia)

This repository is to provide a `C` file that bridges the PATH Solver and the `PATHSolver.jl` package. See [PATHSolver.jl](https://github.com/chkwon/PATHSolver.jl) for details.

To properly compile `src/pathjulia.c` and create `lib/osx/libpath47julia.dylib` and other similar library files, header files from [ampl/pathlib](https://github.com/ampl/pathlib) is necessary.
