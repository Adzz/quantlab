# Quantlab

## Output

Answer can be found in `lib/output.csv`

## Instructions

This problem will require you to write an application that will read an input file ('input.csv') and write out a new file calculated from the inputs.

We are looking for an easily extendable solution with a strong emphasis on readability, even though it may not seem required for this application. We will evaluate your submission based on the following criteria:
- Readability, Design, and Construction
- Tests
- Correctness

We are big fans of test driven development (TDD) and SOLID design principles. Aim to spend about 1 hour to complete this exercise, but please do not spend more than 2 hours. Send your source code and output.csv in a compressed archive for evaluation when complete. Include the amount of time you spent working on the solution. We are looking for modern, idiomatic Elixir with an emphasis on SOLID design principles.

Tips:
- Use the 1-2 hour limit as a guiding constraint.
- Expect that your code will be extended in the future.
- Send us code you would put in production.
- Use any external libraries that make sense, but please do not submit a solution that makes use of Explorer Data Frames.
- Feel free to create your solution in whatever form you wish (Mix project, Elixir Script, or LiveBook)

Pitfalls you want to avoid:
- If you opt to go the route of an Elixir Script, please still make it from easily testable modules. A procedural scripting solution isn't acceptable.
- Over-designing the CSV reader: While reading a CSV file is part of the exercise, don't over think it. This should be the last of your design priorities. Feel free to use an external library for CSV parsing.
- Do not go overboard with use of OTP. Think about how you could extend the application with OTP in the future to handle scalability, but keep your initial solution simple.
- Pay attention to the constraint below: The solution must be able to handle a source dataset well beyond the amount memory and hard disk space on your machine.

-Enjoy!
--Quantlab

_______________________________________________________________________________

Input:

The input file represents a very simplified stream of trades on an exchange.
Each row represents a trade.  If you don't know what that means don't worry.
The data can be thought of as a time series of values in columns:

```
<TimeStamp>,<Symbol>,<Quantity>,<Price>
```

Definitions

- TimeStamp is value indicating the microseconds since midnight.
- Symbol is the 3-character unique identifier for a financial
  instrument (Stock, future etc.)
- Quantity is the amount traded
- Price is the price of the trade for that financial instrument.

Safe Assumptions:
- TimeStamp is always for the same day and won't roll over midnight.
- TimeStamp is increasing or same as previous tick (time gap will never be < 0).
- Price - our currency is an integer-based currency.  No decimal points.
- Price - Price is always > 0.

Example: here is a row for a trade of 10 shares of aaa stock at a price of 12
1234567,aaa,10,12

Problem:
Find the following on a per symbol basis:
- Maximum time gap
  (time gap = Amount of time that passes between consecutive trades of a symbol)
  if only 1 trade is in the file then the gap is 0.
- Total Volume traded (Sum of the quantity for all trades in a symbol).
- Max Trade Price.
- Weighted Average Price.  Average price per unit traded not per trade.
  Result should be truncated to whole numbers.

  Example: the following trades
  20 shares of aaa @ 18
  5 shares of aaa @ 7
  Weighted Average Price = ((20 * 18) + (5 * 7)) / (20 + 5) = 15

Output:
Your solution should produce a file called 'output.csv'.
file should be a comma separate file with this format:
```
<symbol>,<MaxTimeGap>,<Volume>,<WeightedAveragePrice>,<MaxPrice>
```

The output should be sorted by symbol ascending ('aaa' should be first).

Constraint:
Although the provided input file is small, the solution must be able to handle
a source dataset well beyond the amount memory and hard disk space on your machine.

Sample Input:
```
52924702,aaa,13,1136
52924702,aac,20,477
52925641,aab,31,907
52927350,aab,29,724
52927783,aac,21,638
52930489,aaa,18,1222
52931654,aaa,9,1078
52933453,aab,9,756
```
Sample Output:
```
aaa,5787,40,1161,1222
aab,6103,69,810,907
aac,3081,41,559,638
```

Send your source code and output.csv in a compressed archive back for evaluation when complete.
Include the amount of time you spent working on the solution.
