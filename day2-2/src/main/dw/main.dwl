%dw 2.0
input payload application/csv header=false 
output application/json

fun parseSet(obj)=
obj splitBy ";"
map ((item, index) -> trim(item) splitBy " ")
reduce ((item, acc={}) -> acc ++ "$(item[1])": item[0] as Number)
---
(payload map ((item, index) -> do {
  var game = item pluck ((value, key, index) -> 
    if(key startsWith "set") 
      parseSet(value) ++ {id:item.id}
    else null
  ) filter $ != null
  ---
  game
})) map ((item, index) -> do {
    var r = max(item..red default [0])
    var g = max(item..green default [0])
    var b = max(item..blue default [0]) 
    var power= r*g*b
    ---
    power
}) reduce $$+$