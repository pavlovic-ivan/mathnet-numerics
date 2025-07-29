#!/bin/bash

set -e
export VERSION=2025.2
export INTEL=/opt/intel
export MKL=$INTEL/oneapi/mkl/$VERSION
export OPENMP=$INTEL/oneapi/compiler/$VERSION/linux/compiler/lib
export OUT=../../../out/MKL/Linux

mkdir -p $OUT/x64
mkdir -p $OUT/x86

echo "Looking for libiomp5.so in: $OPENMP/intel64_lin"
ls -l "$OPENMP/intel64_lin/libiomp5.so"


g++ -std=c++11 -D_M_X64 -DGCC -m64 --shared -fPIC -o $OUT/x64/libMathNetNumericsMKL.so -I$MKL/include -I../Common -I../MKL ../MKL/memory.c ../MKL/capabilities.cpp ../MKL/vector_functions.c ../Common/blas.c ../Common/lapack.cpp ../MKL/fft.cpp -Wl,--start-group  $MKL/lib/intel64/libmkl_intel_lp64.a $MKL/lib/intel64/libmkl_intel_thread.a $MKL/lib/intel64/libmkl_core.a -Wl,--end-group -L$OPENMP/intel64_lin -liomp5 -lpthread -lm

cp $OPENMP/intel64_lin/libiomp5.so  $OUT/x64/

g++ -std=c++11 -D_M_IX86 -DGCC -m32 --shared -fPIC -o $OUT/x86/libMathNetNumericsMKL.so -I$MKL/include -I../Common -I../MKL ../MKL/memory.c ../MKL/capabilities.cpp ../MKL/vector_functions.c ../Common/blas.c ../Common/lapack.cpp ../MKL/fft.cpp  -Wl,--start-group $MKL/lib/ia32/libmkl_intel.a $MKL/lib/ia32/libmkl_intel_thread.a $MKL/lib/ia32/libmkl_core.a -Wl,--end-group -L$OPENMP/ia32_lin -liomp5 -lpthread -lm

cp $OPENMP/ia32_lin/libiomp5.so  $OUT/x86/
