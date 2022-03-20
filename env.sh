#!/bin/sh

export LUADEVDIR="$(realpath ".")"

test() {
    "$LUADEVDIR/luarocks" build --nodeps
    for i in $(find "$LUADEVDIR/tests" -name "*.lua"); do
        "$LUADEVDIR/lua" "$i"
    done 2>&1
}

build() {
    "$LUADEVDIR/luarocks" build
}

export PATH="$LUADEVDIR/lua_modules/bin:$PATH"

