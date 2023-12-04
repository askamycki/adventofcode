%dw 2.0
input payload application/csv header=false
output application/json
---
payload map ((item, index) -> do {
    var numbers = flatten (item.line scan /[0-9]/) // Extract numbers into an array
    ---
    numbers[0] ++ numbers[-1] // Combine first and last digit
}) reduce $$+$ // Sum all the numbers in the list