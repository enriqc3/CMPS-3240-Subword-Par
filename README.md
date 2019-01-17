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

For reference, this is what i get with an unoptimized code:

```shell
$ for i in {1..3}; do time ./bench_faxpy.out 200000000; done;
Benchmarking FAXPY operation on an array of size 100000000 x 1

real    0m0.565s
user    0m0.352s
sys     0m0.212s
Benchmarking FAXPY operation on an array of size 100000000 x 1

real    0m0.559s
user    0m0.376s
sys     0m0.180s
Benchmarking FAXPY operation on an array of size 100000000 x 1

real    0m0.508s
user    0m0.340s
sys     0m0.164s
```

# Check off

For credit:

* `./test_faxpy.out` should run without any segmentation faults
* Demonstrate some improvement with your optimized code
