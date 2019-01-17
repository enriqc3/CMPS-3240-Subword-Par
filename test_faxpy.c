#include <stdio.h>
#include <stdlib.h>
#include "myblas.h"

#define SIZE 100000000

int main( void ) {
    float *x = (float *) malloc( SIZE * sizeof(float) );
    float *y = (float *) malloc( SIZE * sizeof(float) );
    float *result = (float *) malloc( SIZE * sizeof(float) );

    // First test: N=1
    printf( "Running a test on your implementation of FAXPY to make sure it works.\nFirst test: multiply two scalars (N=1)\n" );
    faxpy( 1, 1.0, x, y, result );

    // Second test: N = SIZE
    printf( "Second test: multiply two vectors of size %d\n", SIZE );
    faxpy( SIZE, 1.0, x, y, result );

    free( x );
    free( y );
    free( result );

    return 0;
}
