/* FAXPY - Single precision a x plus y
 *
 *  Carries out the following operation:
 *
 *  a * x + y
 *
 *  where a is a scalar, and x and y are vectors of the same size n. 
 */
void faxpy( int n, float a, float *x, float *y, float *result ) {
    for( int i = 0; i < n; i++ )
        result[i] = a * x[i] + y[i];
}
