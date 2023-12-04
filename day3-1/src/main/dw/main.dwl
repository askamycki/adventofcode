%dw 2.0
input payload text/plain 
output application/dw

import * from dw::core::Strings
import mergeWith from dw::core::Objects

fun getNumberTokens(line) = do { 
  var tokens = flatten (line scan /[0-9]+/) filter not isEmpty($)
  var idx = flatten (line find /[0-9]+/) filter not isEmpty($)
  ---
  tokens zip idx
}

fun isPartNumber(number, matrix, row, position) = do { 
  var rowSize = sizeOf(matrix[row].line) -1
  var init = if(position -1 < 0) 0 else position -1
  var end = if(position + sizeOf(number) > rowSize) rowSize else position + sizeOf(number)
  var adjacents = init to end
  var a = if (row-1 < 0) false else log(adjacents) reduce ((column, acc=false) -> acc or isSymbol(matrix[row-1].line[(column)]))
  var b = adjacents reduce ((column, acc=false) -> acc or isSymbol(matrix[row].line[column]))
  var c = if (row+1 >= sizeOf(payload)) false else adjacents reduce ((column, acc=false) -> acc or isSymbol(matrix[row+1].line[column]))
  ---
  a or (b) or (c)
}

fun isSymbol(sym)= not (sym matches /[0-9a-zA-Z.]/)
---
payload flatMap ((line, i) -> do {
  var numbers = getNumberTokens(line.line)
  ---
  numbers map ((number, j) -> 
    if(isPartNumber(log(number[0]), payload, i, number[1])) number[0] as Number else 0
  )
}) reduce $$+$
// isPartNumber("467",payload,0)