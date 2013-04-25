package="vararg"
version="1.1-1"
source = {
   url = "https://github.com/moteus/lua-vararg/archive/v1.1.zip",
   dir = "lua-vararg-1.1",
}
description = {
   summary = "Manipulation of variable arguments",
   detailed = [[
      'vararg' is a Lua library for manipulation of variable arguments (vararg) of
      functions. These functions basically allows you to do things with vararg that
      cannot be efficiently done in pure Lua, but can be easily done through the C API.
   ]],
   homepage = "http://www.tecgraf.puc-rio.br/~maia/lua/vararg/",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.1"
}

build = {
   copy_directories = {},
   type = "builtin",
   modules = {
      vararg = {
         sources = "vararg.c",
      },
   },
}
