%dw 2.0
import * from dw::core::Strings
import mergeWith from dw::core::Objects
import * from dw::core::Arrays

input payload application/csv header=false 
output application/json

fun parseSet(obj)=
obj splitBy ";"
map ((item, index) -> trim(item) splitBy " ")
reduce ((item, acc={}) -> acc ++ "$(item[1])": item[0] as Number)
---
(((payload map ((item, index) -> do {
  var game = item pluck ((value, key, index) -> 
    if(key startsWith "set") 
      parseSet(value) ++ {id:item.id}
    else null
  ) filter $ != null
  ---
  game
})) filter ((item, index) -> do {
    var keepRecord = 
        max(item..red default [0]) <=12
    and max(item..blue default [0]) <=13
    and max(item..green default [0]) <=14
    ---
    keepRecord
}))..id distinctBy $) reduce $+$$ 