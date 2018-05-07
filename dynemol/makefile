
.SUFFIXES: .f .F .for .cpp .F90 .cu .o

# Fortran compiler:
FC = ifort

# Basic options:
# -fpp:		Runs Fortran's preprocessor before compilation
# -align:	Prevents padding bytes in arrays and structs
F_BASIC = -fpp -align

# Optimization options:
# -xHost:	Generate code for the highest instruction set on the host processor
# -ip:		Enables interprocderual optimizations
F_OPTIMIZE = -xHost -ip

# Parallel options:
# -qopenmp:		Enables generation of multi threaded code based on OpenMP directives
# -parallel:	Tells compiler to auto generate multi threaded code where it sees
# 				fit
F_PARALLEL = -qopenmp -parallel

# DEBUG OPTIONS
# use this flag for debugging and coding up
# check all: Enables checks at run time (disables O optimizations)
# traceback: Compiler generate more useful info in the object files
# fstack-protector: Enables stack overflow protection
# assume protect_parens: Do not make reassociations with parenthesis
# warn all: Enables all warning messages
SAFE = #-check all -traceback -fstack-protector -assume protect_parens -implicitnone -warn all


# C/C++ Compiler:
CXX = icpc

# Basic options:
# std=c++11:	C++ 11 standard
# -align:		Prevents padding bytes in arrays and structs
C_BASIC = -std=c++11 -align

# Optimization options:
# -xHost:	Generate code for the highest instruction set on the host processor
# -ip:		Enables interprocderual optimizations
C_OPTIMIZE = -xHost -ip

# Safe options:
# -fno-exceptions:	Disables the generation of exceptions table generation. When
# 					used, code will be smaller but try blocks will throw an
# 					error
# -restrict: 		Assures that an object is only accessed by a single pointer
# 					in it's scope
C_SAFE = -fno-exceptions -restrict

# Parallel options:
# -align:	Prevents padding bytes in arrays and structs
# -qopenmp:	Enables generation of multi threaded code based on OpenMP directives
C_PARALLEL = -qopenmp -fno-exceptions

# Libraries:
# - If MKLROOT is not defined in your environment, edit and uncomment the line
# 	below
# MKLROOT = MKL location
LIB_BLAS   = -lmkl_blas95_lp64
LIB_LAPACK = -lmkl_lapack95_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core
LIB_OMP    = -liomp5 -lpthread
INCS_MKL   = -I$(MKLROOT)/include/intel64/lp64 -I$(MKLROOT)/include/fftw

# Uncomment the lines below when compiling for GPUs
# GPU_DEFS options:
#   -DGPU_TIMING       : Print timings (CPU/GPU)
#   -DUSE_GPU          : Compile with GPU support
#   -DGPU_DEBUG        : Print some debug messages
#   -DGPU_SYGVDM_VER   : Use multi-gpu version of SYGVD (faster than single-gpu even with 1 gpu)
#   -DGPU_SYGVD2S_VER  : Use two stage version of SYGVD (faster, but needs more memory)
#   -DGPU_DONT_PIN_MEM : Don't use pinned memory for faster transfers (in Fortran code)
#   -DGPU_PIN_MEM_WORK : Use pinned memory for work spaces (in C code)
#GPU_DEFS  = -DUSE_GPU
#
#NVCC      = nvcc
#NVCCFLAGS = -O3 -arch=sm_35 -Xcompiler "-fno-strict-aliasing -march=native -fno-exceptions"
#
# CUDA and MAGMA paths:
#CUDADIR   = /usr/local/cuda
#MAGMADIR  = /opt/magma-2.1.0
#
# CUDA and MAGMA libs:
#LIB_CUDA  = -L$(CUDADIR)/lib64 -lcublas -lcusparse -lcudart
#LIB_MAGMA = $(MAGMADIR)/lib/libmagma.a
#
#LIB_GPU   = $(LIB_MAGMA) $(LIB_CUDA) -lstdc++
#INCS_GPU  = -I$(CUDADIR)/include -I$(MAGMADIR)/include

LIB  = $(LIB_GPU) $(LIB_BLAS) $(LIB_LAPACK) $(LIB_OMP) -lrt
INCS = $(INCS_MKL)

#-----------------------------------------------------------------------
# general rules
#-----------------------------------------------------------------------

#INCS1   = comun.inc integcoul.inc m2cdat.inc $(INCS)

SOURCE1 = integ-Coul.o \
		  Coul0sim.o \
		  m2caux3-Coul.o \
		  abcpes-Coul.o \
		  ckplm-Coul.o \
		  util-Coul.o

SOURCE2 = constants_m.o \
		  Matrix_math.o \
		  exec_time.o \
		  types_EHT.o \
		  types_MM.o \
		  OPT_parent.o \
		  parameters.o \
		  parameters_MM.o \
		  allocation_m.o \
		  util.o \
		  EHT_input.o \
		  tuning.o \
          IdentifyNonBonded.o \
		  babel_routines.o \
		  babel.o \
		  gmx2mdflex.o \
		  structure.o \
		  md_read.o	\
		  md_setup.o \
		  f_intra.o \
		  f_inter.o \
		  md_output.o \
		  pbc.o \
		  overlap_D.o \
		  Ehrenfest.o \
		  HuckelForces.o \
		  STO.o \
		  multip_routines.o \
		  electron_hole_DP.o \
		  LCMO_Builder.o \
		  FMO.o \
		  DP_main.o \
		  td_dp.o \
		  DP_FMO.o \
		  dipole_phi.o \
		  Coulomb.o \
		  polarizability.o \
		  CoulInt_QMMM.o \
		  QCModel_Huckel.o \
		  QCModel_ElHl.o \
		  AlphaPolar.o \
		  data_output.o \
          backup_MM.o \
		  Berendsen.o \
		  NoseHoover.o \
		  NoseHoover_Reversible.o \
          NVE.o \
		  VDOS_m.o \
		  MM_dynamics.o \
		  MM_driver.o \
		  film_STO.o \
		  DOS_m.o \
		  oscillator.o \
		  ga_QCModel.o \
		  cost_tuning_EH.o \
		  cost_tuning_MM.o \
		  nonlinearCG.o \
		  CG_class.o \
		  MM_ERG_class.o \
		  nonlinear-sidekick.o \
		  FF_OPT_class.o \
		  CG_EH_driver.o \
		  ga_routines.o \
		  CG_MM_driver.o \
		  vibes_driver.o \
		  solvated_M.o \
		  DOS_tool.o \
		  backup.o \
		  auto_correlation.o \
		  ElHl_schroedinger.o \
		  diagnostic.o \
		  qdynamics.o \
		  Chebyshev.o \
		  ElHl_Chebyshev.o \
		  AO_adiabatic.o \
		  ElHl_adiabatic.o \
		  Chebyshev_driver.o \
		  eigen_driver.o \
		  ga_driver.o \
		  avrg_confgs.o \
 		  main.o

SOURCE_GPU = GPU_Interface.o \
             Chebyshev_gpu.o

ifneq (,$(findstring USE_GPU,$(GPU_DEFS)))
SOURCE_CUDA= Chebyshev_gpu_kernels.o \
             dzgemv_kernels.o
endif


a: $(SOURCE1) $(SOURCE2) $(SOURCE_GPU) $(SOURCE_CUDA)
	rm -f a
	$(FC) $(INCS_MKL) -o a $(SOURCE1) $(SOURCE2) $(SOURCE_GPU) $(SOURCE_CUDA) $(LIB)
	-rm -f *.log


# Removes all the parallel flags from compiling options
serial: F_PARALLEL =
serial: C_PARALLEL =
serial: debug clean ret a

# Recompiles everything with debug flag
debug: CXX +=  -g
debug: FC +=  -g
debug: clean ret a


.f.o:
	$(FC) -O2 -free -static $(F_BASIC) $(F_OPTIMIZE) $(F_PARALLEL) $(INCS_MKL) $(GPU_DEFS) -c $<

.F.o:
	$(FC) -O3 $(F_BASIC) $(F_OPTIMIZE) $(INCS_MKL) -c $<

.F90.o:
	$(FC) -O3 $(F_BASIC) $(F_OPTIMIZE) $(INCS_MKL) $(GPU_DEFS) -c $<

.cpp.o:
	$(CXX) $(C_BASIC) $(C_OPTIMIZE) $(C_SAFE) $(C_PARALLEL) $(INCS_GPU) $(GPU_DEFS) -c $<

.cu.o:
	$(NVCC) $(NVCCFLAGS) $(INCS_GPU) $(GPU_DEFS) -c $<


clean:
	-rm -fv a *.o *.mod && touch *.f

# Needs to check if this can be done with the -gen-deps flag
depend:
	@echo -en "Searching module dependencies..."
	@chmod +x ./makedepend.bsh
	@./makedepend.bsh > dependencies.txt
	@echo -en " done.\n"


ret:
	cd inputs/ && \
	make ret

prc:
	cd inputs/ && \
	make prc

## Dependency list:
-include dependencies.txt

