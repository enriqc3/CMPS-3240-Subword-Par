# CMPS-3240-Subword-Par
Advanced subword parallelism with x86 assembly language and the SSE instruction set

# Introduction

## Objectives

* Apply your knowledge of SIMD and SSE instructions to the single precision A time X plus y (FAXPY) operation

## Prerequisites

* Understand how SIMD works with SSE and x86

## Requirements

### General

* Understanding of the FAXPY operation (see `myblas.c`).

### Software

This lab requires `gcc`, `make`, and `git`.

### Hardware

x86 CPU with the SSE instruction set.

### Compatability

| Linux | Mac | Windows |
| :--- | :--- | :--- |
| Yes<sup>*</sup> | Untested<sup>*</sup> | Untested<sup>*</sup> |

<sup>*</sup>This lab should work across all environments, assuming you set up `gcc` correctly. The lab manuel is written for `odin.cs.csubak.edu`, but it should not be too much of a stretch in other environments. The only concern is if you're using Windows, you need to use `movapd` instead of `movupd` (notice the subtle difference with the `a` and the `u`. Windows stores SIMD arrays in a particular way (aligned) that is different from POSIX OS (unaligned).

## Background

The topic of today's lab is to apply your knowledge of SSE and x86 to optimize the FAXPY operation. It takes two vectors of identical size and steps through the arrays, multiplying a scalar value to the first array element and adding the result to the second array element. Perhaps it's easier to just look at the code from `myblas.c`:

```c
void faxpy( int n, float a, float *x, float *y, float *result ) {
    for( int i = 0; i < n; i++ )
        result[i] = a * x[i] + y[i];
}
```

One thing to note is that we are operating on *floats* and not *doubles*. In the previous lab, the MM registers were divided as follows:

| First half of an `%xmm` register | Second half of an `%xmm` register |
| --- | --- |
| `array[i]` | `array[i+1]` |

Because the `%xmm` registers are 128 bits--large enough for two doubles. We are working with singles in this lab (`float`s), so it will look like this:

| First quarter | Second quarter | Third quarter | Fourth quarter |
| --- | --- | --- | --- |
| `array[i]` | `array[i+1]` | `array[i+2]` | `array[i+3]` |

Functionally, this means we have to change the suffix of our SIMD instructions. For example, we used `mouvpd` and `movusd` for unaligned packed and unaligned scalar movement operations with doubles. For this lab, the suffix would change to: `movups` and `movuss` respectively. The last character indicates the operation should be single precision. Also, since we are operating on chunks of four instead of two, we should increment our index counter `i` by units of 4, rather than 2. Finally, the FAXPY operation is an addition, not a multiplication, so be sure to use the `add` instruction rather than a multiplication.

### Broadcasting vs. Packing

The act of packing a multimedia register takes successive values from an array and places them into an oversized register. With the AXPY operation, we carry out the following:

1. Multiply a scalar `a` times `x[i]`
2. Add the result from 1. to `y[i]`
3. Store the result from 2. into `result[i]`

Operation 2. uses packed operations. However, in operation 1., this is different. We must take a single value and repeat it across the many positions in the oversized register. The operation to do this in x86 is `vbroadcast`, and we are using singles so you should use the `ss` suffix. For example:

```x86
vbroadcastss    $1, %xmm2
```

will broadcast the literal `$1` to four positions in the 128-bit-sized register `%xmm2`. *Tip: It should be safe for you to use %xmm0 through %xmm7 as scratch registers. The code as given is using %xmm0 and %xmm1.*

# Approach

The approach for this lab is as follows:

1. Study `myblas.c` to understand whats going on at a high level
1. Study `myblas.s` to understand whats going on at the assembly level
1. Apply what you learned in the last lab to optimize `myblas.s` with SSE instructions
1. Assemble the binary file with the `make all` target
1. Run `./test_faxpy.out` to make sure it works
1. Get timings by taking the average of `time ./bench_faxpy.out` three times. Compare this to the unoptimized version. 

Some tips:

* Carefully read the background to see what instructions you need to use this time
* If you want to start your `myblas.s` file over from scratch use the `make reset` target
* Don't forget to increment the array counter in units of 4

For reference, this is what i get with an unoptimized code on a machine with an Intel Xeon E5-2630 v2 running at 2.60GHz:

```shell
$ for i in {1..3}; do time ./bench_faxpy.out 200000000; done;
Benchmarking FAXPY operation on an array of size 100000000 x 1

real	0m0.700s
user	0m0.484s
sys	0m0.216s
Benchmarking FAXPY operation on an array of size 100000000 x 1

real	0m0.692s
user	0m0.456s
sys	0m0.236s
Benchmarking FAXPY operation on an array of size 100000000 x 1

real	0m0.702s
user	0m0.461s
sys	0m0.241s
```

These are the result I get on the same machine, after altering the assembly code to carry out SIMD:

```shell
$ for i in {1..3}; do time ./bench_faxpy.out 200000000; done;
Benchmarking FAXPY operation on an array of size 100000000 x 1

real	0m0.398s
user	0m0.171s
sys	0m0.227s
Benchmarking FAXPY operation on an array of size 100000000 x 1

real	0m0.395s
user	0m0.172s
sys	0m0.223s
Benchmarking FAXPY operation on an array of size 100000000 x 1

real	0m0.392s
user	0m0.132s
sys	0m0.260s
```

# Check off

For credit:

* `./test_faxpy.out` should run without any segmentation faults
* Demonstrate some improvement with your optimized code
