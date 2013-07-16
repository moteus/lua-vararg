##Unofficial repositary of [vararg](http://www.tecgraf.puc-rio.br/~maia/lua/vararg)
[![Build Status](https://travis-ci.org/moteus/lua-vararg.png?branch=master)](https://travis-ci.org/moteus/lua-vararg)

`vararg` is a Lua library for manipulation of variable arguements (vararg) of
functions. These functions basically allow you to do things with vararg that
cannot be efficiently done in pure Lua but can be easily done through the C API.

Actually, the main motivation for this library was the 'pack' function, which
is an elegant alternative for the possible new standard function 'table.pack'
and the praised 'apairs'. Also 'pack' allows an interesting implementaiton of
tuples in pure Lua.

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
| range(i, j, ...)   | unpack({...}, i, j)                                      |
| remove(i, ...)     | unpack(tremove({...},i),1,select("#",...)-1)             |
| insert(v, i, ...)  | unpack(tinsert({...},i,v),1,select("#",...)+1)           |
| replace(v, i, ...) | unpack(tset({...}, i, v) t,1,select("#",...))            |
| append(v, ...)     | unpack(tappend({...},v),1,select("#",...)+1)             |
| map(f, ...)        | t={} for i, arg in pack(...) do t[i]=f(arg) end unpack(t)|
| concat(f1,f2,...)  | return all the values returned by functions 'f1,f2,...'  |
