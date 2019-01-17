CC=gcc
FLAGS=-O0 -Wall
BLAS_ASM=myblas.s

all: bench_faxpy.out test_faxpy.out

# Targets to make our benchmark binary
bench_faxpy.o: bench_faxpy.c myblas.h
	${CC} ${FLAGS} -o $@ -c $<
bench_faxpy.out: bench_faxpy.o myblas.o
	${CC} ${FLAGS} -o $@ $^

# Targets to make the test program
test_faxpy.o: test_faxpy.c myblas.h
	${CC} ${FLAGS} -o $@ -c $<
test_faxpy.out: test_faxpy.o myblas.o
	${CC} ${FLAGS} -o $@ $^


# Targets to generate our BLAS library
myblas.o: myblas.s
	${CC} ${FLAGS} -o $@ -c $<

# To generate myblas.s. Do not put this in 'all'. Only call this if you want to
# restart your work on 'myblas.s'.
reset: myblas.c
	rm ${BLAS_ASM}
	${CC} ${FLAGS} -S $< -o ${BLAS_ASM}

clean: 
	rm -f *.o *.out
