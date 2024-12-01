# DevLisEspressoAlgo
**CAD VLSI Sec:0001**  
**Project #1** by Devon Lister

This project was programmed in Haskell as both a personal learning exercise and a challenge to tackle an uncomfortable task while learning something new (similar to fixing a car while driving).



## Compilation and Running
```bash
To compile the program, I use **GHC** (Glasgow Haskell Compiler) with the following command:


ghc -o DLESP DevLisEspresso.hs

To run the program, use the command:

./DLESP <input.pla> <output.pla> [optional: -d --debug flag]

Note: The debug flag is intended for personal use and won't provide useful information for debugging outside my context.
```
## Program Overview

This program takes in a PLA file as input and outputs a simplified PLA file.

## Known Issues

```

    Don't Cares: The primary issue is that the program removes "don't care" terms entirely, instead of marking them as such. As a result, the output may be incorrect when handling "don't care" conditions, particularly in larger term sets.
    I was unable to implement the functionality in time after realizing this as well.

    Example:
    Input (with don't cares):

    .i 4                              .i 4                                    .i 3
    .o 1            Should become ->  .o 1        However mine looks like  -> .o 1
    0111 1                            .p 1                                    .p 1
    0011 1                            0-11 1                                  011 1
                                    .e                                      .e


Below is a summary of the test cases, with all the ones that did fail did so because of the above labelled issue

Test Case	Passed?
case1	✅	Does it simplify a 3-term SOP (Sum of Products)?
case2	✅	Does it simplify a 6-term SOP?
case3	❌	Does it simplify a 4-term SOP?
case4	❌	Does it simplify a 10-term SOP?
case5	✅	Does it simplify a 6-term SOP?
case6	❌	Does it simplify a 6-term SOP?
case7	❌	Does it simplify case3 repeated 3x?

```

Conclusion: 
This project was challenging but rewarding. While my 2-level minimization algorithm doesn't work perfectly, I gained a solid understanding of the underlying concepts. 
With more time or possibly using a different programming language, I believe I could have improved the implementation(do it correctly). Regardless, this was a fun and interesting experience.
Resources Used

Lectures by Mike Borowczak at the University of Central Florida.

Espresso Web (WASM version) - To compare my output against another tool's output. https://nudelerde.github.io/Espresso-Wasm-Web/index.html

Boolean Algebra Simplification - For checking boolean algebra logic and simplifications. https://www.boolean-algebra.com/

