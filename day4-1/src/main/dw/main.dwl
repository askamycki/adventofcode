%dw 2.0
input payload text/plain 
output application/dw

import * from dw::core::Strings
import * from dw::core::Objects

fun parseLine(line: String): Object = do {
  var tokens = line splitBy ':'
  var cardNumber = (tokens[0] scan /[0-9]+/)[0][0] as Number
  var numbers = trim(tokens[1]) splitBy '|'
  var winningNumbers = flatten (numbers[0] scan /[0-9]+/) map $ as Number
  var cardNumbers = flatten (numbers[1] scan /[0-9]+/) map $ as Number
  ---
  {
    cardNumber: cardNumber,
    winningNumbers: winningNumbers,
    cardNumbers: cardNumbers
  }
}

fun countWinningNumbers(cardNumbers: Array<Number>, winningNumbers: Array<Number>): Number = 
winningNumbers reduce ((winningNumber, accumulator=0) -> if(cardNumbers contains winningNumber) accumulator + 1 else accumulator)
---
(payload.line map ((line, index) -> do {
  var scratchCard = parseLine(line)
  var winningNumbersCount = countWinningNumbers(scratchCard.cardNumbers, scratchCard.winningNumbers)
  var cardPoints = if(winningNumbersCount == 0) 0 else (2 pow winningNumbersCount - 1)
  ---
  {cardNo: scratchCard.cardNumber, cardPoints: cardPoints}
})).cardPoints
reduce $$+$