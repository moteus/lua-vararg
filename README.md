## Unofficial repositary of [vararg](http://www.tecgraf.puc-rio.br/~maia/lua/vararg)
[![Licence](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)
[![Build Status](https://travis-ci.org/moteus/lua-vararg.png?branch=master)](https://travis-ci.org/moteus/lua-vararg)
[![Build status](https://ci.appveyor.com/api/projects/status/8lo89111mnndhdmx?svg=true)](https://ci.appveyor.com/project/moteus/lua-vararg)
[![Coverage Status](https://coveralls.io/repos/moteus/lua-vararg/badge.png?branch=master)](https://coveralls.io/r/moteus/lua-vararg?branch=master)

`vararg` is a Lua library for manipulation of variable arguements (vararg) of
functions. These functions basically allow you to do things with vararg that
cannot be efficiently done in pure Lua but can be easily done through the C API.

Actually, the main motivation for this library was the 'pack' function, which
is an elegant alternative for the possible new standard function 'table.pack'
and the praised 'apairs'. Also 'pack' allows an interesting implementaiton of
tuples in pure Lua.

## Changes since official `vararg` v1.1

* C version supports Lua 5.2/5.3
* Fix bugs on Lua version. Now it pass all tests.
* Lua and C version are fully compatible (excapt error messages).
* Use call metamethod as alias for pack method (`vararg(...)` is same as `vararg.pack(...)`)
* Add `va.count` function
* Add `va.at` function

## pack

`args = pack(...)`

|    vararg           |      lua                  |
|---------------------|---------------------------|
| args()              | ...                       |
| args("#")           | select("#", ...)          |
| args(i)             | (select(i, ...))          |
| args(i, j)          | unpack({...}, i, j)       |
| for i,v in args do  | for i,v in ipairs{...} do |

## vararg methods

Assume this shortcuts
```lua
tremove = function(t, i)    table.remove(t, i)    return t end
tinsert = function(t, i, v) table.insert(t, i, v) return t end
tset    = function(t, i, v) t[i] = v              return t end
tappend = function(t, v)    t[#t+1] = v           return t end
```

|    vararg          |      lua                                                 |
|--------------------|----------------------------------------------------------|
| count(...)         | select("#", ...)                                         |
| range(i, j, ...)   | unpack({...}, i, j)                                      |
| at(i, ...)         | range(i, i, ...)                                         |
| remove(i, ...)     | unpack(tremove({...},i),1,count(...)-1)                  |
| insert(v, i, ...)  | unpack(tinsert({...},i,v),1,count(...)+1)                |
| replace(v, i, ...) | unpack(tset({...}, i, v) t,1,count(...))                 |
| append(v, ...)     | unpack(tappend({...},v),1,count(...)+1)                  |
| map(f, ...)        | t={} for i, arg in pack(...) do t[i]=f(arg) end unpack(t)|
| concat(f1,f2,...)  | return all the values returned by functions 'f1,f2,...'  |

## Examples

Implement basic `bind` function

```Lua
function bind(f, ...)
  local args = va(...)
  return function(...)
    return f(va.concat(args, va(...))
  end
end
debug_print = bint(print, '[debug]')
debug_print('hello')
```

Pack in to array returned values from several functions

```Lua
function f(...) return ... end

t = {va.concat(
  va(f(1,2,3)),
  va(f(4,5,6)),
)}

-- t = {1,2,3,4,5,6}
```

Write to stdout but convert values to string.
```Lua
function write(...)
  return io.write(va.map(tostring, ...))
end

local hello = setmetatable({},{__tostring = function() return "Hello" end})

write(hello, " world!!! ", nil, '\n')
```

Parse IPv4 address
```Lua
local n1,n2,n3,n4 = va.map(tonumber, string.match(ip, "^(%d+)%.(%d+)%.(%d+)%.(%d+)$"))
-- test nX as number
```

