%dw 2.0
import * from dw::core::Strings

input payload application/csv header=false
output application/json

var example = "jvhngkcdjhnmqghdbqdzqssf5onegzjbbcchboneightn"
fun toNumericDigit(digit: String)= digit match { 
    case "one" -> 1
    case "two" -> 2
    case "three" -> 3
    case "four" -> 4
    case "five" -> 5
    case "six" -> 6
    case "seven" -> 7
    case "eight" -> 8
    case "nine" -> 9
    else -> digit
}

fun toNumericDigits(str: String)= str 
replace "oneight" with "18"
replace "one" with "1"
replace "two" with "2"
replace "threeight" with "38"
replace "three" with "3"
replace "four" with "4"
replace "fiveight" with "58"
replace "five" with "5"
replace "six" with "6"
replace "sevenine" with "79"
replace "seven" with "7"
replace "eightwo" with "82"
replace "eighthree" with "83"
replace "eight" with "8"
replace "nineight" with "98"
replace "nine" with "9"
---
(payload map ((item, index) -> do {
    // var digits = flatten (item.line scan /(?:one|two|three|four|five|six|seven|eight|nine|[1-9])/)
    var digits = flatten (toNumericDigits(item.line) scan /[1-9]/)
    map ((digit, idx) -> toNumericDigit(digit))
    ---
    digits[0] ++ digits[-1]
})) //reduce $$+$ // Sum all the numbers in the list
