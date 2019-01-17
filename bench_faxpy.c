#include <stdio.h>
#include <stdlib.h>
#include "myblas.h"

#define SIZE 100000000

int main( void ) {
    printf( "Benchmarking FAXPY operation on an array of size %d x 1\n", SIZE );

    float *x = (float *) malloc( SIZE * sizeof(float) );
    float *y = (float *) malloc( SIZE * sizeof(float) );
    float *result = (float *) malloc( SIZE * sizeof(float) );

    faxpy( SIZE, 1.0, x, y, result );

    free( x );
    free( y );
    free( result );

    return 0;
}
