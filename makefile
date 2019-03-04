CC=gcc
FLAGS=-O0 -Wall

all: bench_faxpy.out

# Targets to make our benchmark binary
bench_faxpy.o: bench_faxpy.c myblas.h
	${CC} ${FLAGS} -o $@ -c $<
bench_faxpy.out: bench_faxpy.o myblas.o
	${CC} ${FLAGS} -o $@ $^

# Be careful not to put your .s file here
clean: 
	rm -f *.o *.out
