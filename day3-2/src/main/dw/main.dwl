%dw 2.0
input payload text/plain 
output application/dw

import * from dw::core::Strings
import * from dw::core::Objects

fun getNumberTokens(line) = do { 
  var tokens = flatten (line scan /[0-9]+/) filter not isEmpty($)
  var idx = flatten (line find /[0-9]+/) filter not isEmpty($)
  ---
  (tokens zip idx) default null
}
fun getGearPositions(line)= 
flatten (line find /\*+/) filter not isEmpty($)

fun findAdjacentNumbers(nt1, nt2, nt3, gearPosition)= do {
  var n1 = flatten (nt1 filter ((item, index) -> do {
    var size = sizeOf(item[0])
    var range = (item[1]-1 to item[1] + size) as Array
    ---
    range contains gearPosition
  }))
  var n2 = flatten(nt2 filter ((item, index) -> do {
    var size = sizeOf(item[0])
    var range = (item[1]-1 to item[1] + size) as Array
    ---
    range contains gearPosition
  }))
  var n3 = flatten(nt3 filter ((item, index) -> do {
    var size = sizeOf(item[0])
    var range = (item[1]-1 to item[1] + size) as Array
    ---
    range contains gearPosition
  }))
  ---
  if (sizeOf(n1) > 2)
    n1[0]*n1[2]
  else if (sizeOf(n2) > 2)
    n2[0]*n2[2]
  else if (sizeOf(n3) > 2)
    n3[0]*n3[2]
  else if (n1[0] != null and n2[0] != null) n1[0]*n2[0] 
  else if(n1[0] !=null and n3[0] != null) n1[0]*n3[0] 
  else if(n2[0] != null and n3[0] != null) n2[0]*n3[0] else null
}

fun calculateGearRatio(l1, l2, l3) = do {
  var nt1 = getNumberTokens(l1)
  var nt2 = getNumberTokens(l2)
  var nt3 = getNumberTokens(l3)
  var gears = getGearPositions(l2) default null
  var adjNums = if (l1 == null or l2 == null or l3 == null or gears == null) null
  else gears map ((item, index) -> 
    findAdjacentNumbers(nt1, nt2, nt3, item)
  ) 
  ---
  adjNums 
}

var lines = (0 to sizeOf(payload)) as Array
---
flatten (lines map ((item, index) -> 
  calculateGearRatio(payload[index].line, payload[index+1].line, payload[index +2].line) 
)) 
filter $ != null
reduce $$+$