import Data.List (nub, delete, isPrefixOf)
import Data.Maybe (isJust, fromJust)
import System.IO
import System.Environment (getArgs)

type Literal = (String, Bool)
type Term = [Literal]
type SOP = [Term]

---
--PLA FILE INPUT
---
parsePLA :: String -> SOP
parsePLA content =
    let linesContent = filter (not . null) $ map (takeWhile (/= '#')) $ lines content
        inputsLine = head $ filter (".i" `isPrefixOf`) linesContent
        inputVars = read (drop 3 inputsLine) :: Int
        sopLines = filter (all (`elem` "01- ")) linesContent
        vars = take inputVars $ map (:[]) ['A' ..] 
    in map (parseTerm vars) sopLines

parseTerm :: [String] -> String -> Term
parseTerm vars line =
    let (inputs, _) = span (`elem` "01-") line
    in zipWith (\v c -> (v, c == '1')) vars inputs

---
--PLA FILE Output
---
toPLA :: SOP -> String
toPLA sop =
    let inputs = length $ nub $ concatMap (map fst) sop
        outputs = 1  -- Lol absolutely won't change
        header = ".i " ++ show inputs ++ "\n.o " ++ show outputs ++ "\n"
        pLine = ".p " ++ show (length sop) ++ "\n"
        body = unlines $ map termToPLA sop
        footer = ".e\n"
    in header ++ pLine ++ body ++ footer

termToPLA :: Term -> String
termToPLA term =
    concatMap (\(_, val) -> if val then "1" else "0") term ++ " 1"


---
--Step one of Esspresso Algo
---
generatePrimeImplicants :: SOP -> SOP
generatePrimeImplicants sop = iterativelyCombine sop []
  where
    iterativelyCombine [] primes = nub primes
    iterativelyCombine terms primes =
        let (combined, leftover) = combineAll terms []
        in if null combined
           then nub (primes ++ leftover)
           else iterativelyCombine combined (primes ++ leftover)

combineAll :: SOP -> SOP -> (SOP, SOP)
combineAll [] leftover = ([], leftover)
combineAll (t:ts) leftover =
    let (combinedWithT, remaining) = foldl (\(comb, rem) term -> case combineTerms t term of
                                                    Just newTerm -> (newTerm : comb, rem)
                                                    Nothing      -> (comb, term : rem))
                                            ([], []) ts
        (combinedRest, newLeftover) = combineAll remaining leftover
    in (nub (combinedWithT ++ combinedRest), nub (newLeftover ++ [t | null combinedWithT]))

combineTerms :: Term -> Term -> Maybe Term
combineTerms term1 term2 =
    let differingLiterals = [(l1, l2) | l1 <- term1, l2 <- term2, fst l1 == fst l2 && l1 /= l2]
    in if length differingLiterals == 1
       then Just $ nub [l | l <- (term1 ++ term2), fst l /= fst (fst (head differingLiterals))]
       else Nothing

--
--Step 2, find covers and essential implicants
--
covers :: Term -> Term -> Bool
covers term minterm = all (`elem` term) minterm

findEssentialImplicants :: SOP -> SOP -> SOP
findEssentialImplicants primes sop =
    [prime | prime <- primes, coversUnique prime sop]
  where
    coversUnique prime sop =
        let coveredMinterms = filter (covers prime) sop
        in length coveredMinterms == 1

performMinimalCover :: SOP -> SOP -> SOP
performMinimalCover primes sop =
    let essentials = findEssentialImplicants primes sop
        remainingMinterms = filter (\m -> not (any (`covers` m) essentials)) sop
    in essentials ++ minimalCover primes remainingMinterms

minimalCover :: SOP -> SOP -> SOP
minimalCover _ [] = []
minimalCover primes (minterm:rest) =
    let coveringPrimes = filter (`covers` minterm) primes
    in if null coveringPrimes
       then minimalCover primes rest
       else
           let bestPrime = head coveringPrimes
           in bestPrime : minimalCover primes (filter (\m -> not (covers bestPrime m)) rest)
--
--Step 3, optimize and remove, garuntee certain covers
--
optimizeSOP :: SOP -> SOP
optimizeSOP sop =
    let simplified = nub $ map removeRedundantLiterals sop
    in removeRedundantTerms simplified

removeRedundantLiterals :: Term -> Term
removeRedundantLiterals term =
    foldr tryRemovingLiteral term term
  where
    tryRemovingLiteral :: Literal -> Term -> Term
    tryRemovingLiteral literal currentTerm =
        let smallerTerm = delete literal currentTerm
        in if all (`covers` currentTerm) [smallerTerm]
           then smallerTerm
           else currentTerm

removeRedundantTerms :: SOP -> SOP
removeRedundantTerms sop =
    filter (\t -> not (any (\other -> other `covers` t && other /= t) sop)) sop

--
--Esspresso algo run
--
espressoWithPrimes :: SOP -> (SOP, SOP, SOP)
espressoWithPrimes sop =
    let primes = generatePrimeImplicants sop
        minimized = performMinimalCover primes sop
        optimized = if null minimized then primes else minimizeFurther minimized
    in (primes, minimized, optimized)

--Redundent
minimizeFurther :: SOP -> SOP
minimizeFurther sop =
    let simplified = optimizeSOP sop
    in if null simplified then sop else simplified
--Debug printer, convience func statement
debugPrint :: Bool -> String -> IO ()
debugPrint debug message =
    if debug then putStrLn message else return ()

-- Main function
main :: IO ()
main = do
    args <- getArgs
    let debug = "--debug" `elem` args || "-d" `elem` args
    if length args < 2
        then putStrLn "./minimizeSOP <input.pla> <output.pla>"
        else do
            let inputFile = head args
            let outputFile = args !! 1

            content <- readFile inputFile
            let sop = parsePLA content

            debugPrint debug "Original SOP:"
            debugPrint debug (show sop)

            let (primes, minimized, optimized) = espressoWithPrimes sop
            debugPrint debug "\nPrimes:"
            debugPrint debug (show primes)
            debugPrint debug "\nMinimized SOP:"
            debugPrint debug (show minimized)
            debugPrint debug "\nOptimized SOP:"
            debugPrint debug (show optimized)

            let outputContent = toPLA optimized
            writeFile outputFile outputContent
            putStrLn $ "\nOptimized SOP written to " ++ outputFile