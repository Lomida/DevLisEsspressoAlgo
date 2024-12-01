# DevLisEsspressoAlgo
CAD VLSI Sec:0001 Devon Lister Project#1

This was programmed in Haskell both as a learning excercise for myself and to see if I could both an uncomfortable task while learning something( fixing the car while driving).
To compile this I am using GHC (Glasgow Haskell Compiler) and running the command
ghc -o DLESP DevLisEspresso.hs

Then to run it I use, the optional debug flag isn't meant for debugging outside of my personal use and won't give off information particular useful to anyone 
./DLESP <input.pla> <output.pla> <optional: -d --debug flag>

This program takes in a PLA file and outputs a PLA file
There are errors, the main issue is don't cares because my code removes them entirely instead of labelling them as such. I can't implement the functionality in time.
For example: 

.i 4                              .i 4                                    .i 3

.o 1            Should become ->  .o 1        However mine looks like  -> .o 1

0111 1                            .p 1                                    .p 1

0011 1                            0-11 1                                  011 1
                                  .e                                      .e

This is especially annoying when doing larger sets of terms because removing multiple letters at different spots makes it unreadable 
I've created 7 test cases to show what it does correct and incorrect.

| What cases failed? | What was the test case?               |

|------------------------------------------------------------|

| case1     ✅       | Does it simplify a 3 in 3 term SOP?   

| case2     ✅       | Does it simplify a 3 in 6 term SOP?   

| case3     ❌       | Does it simplify a 4 in 2 term SOP?   | It failed because it was unable to handle 2nd level don't cares removing them and then not including them in the output, see example at top above for issue

| case4     ❌       | Does it simplify a 4 in 10 term SOP?  | ^ same as above

| case5     ✅       | Does it simplify a 6 in 2 term SOP?

| case6     ❌       | Does it simplify a 6 in 4 term SOP?   | ^ same as above

| case7     ❌       | Does it simplify case3 repeated 3x    | ^ same as above, however it also adds in additional term which is also unpredicted, implies another issue is also happening

|------------------------------------------------------------|

Overall this was a difficult project that with more time and maybe a different language implementation could have gone better but I do not regret trying this out. This was very fun and intresting to do, while my code for a 2 level minimization algorithm doesn't work, I absolutely can do it by hand and grasp the concept. 

All resources used are as follows: 

Lecutres by Mike Borowczak at the University of Central Florida.

https://nudelerde.github.io/Espresso-Wasm-Web/index.html to check my output aganist another output

https://www.boolean-algebra.com/ to check boolean algebra logic and the simplifcations I should be getting
