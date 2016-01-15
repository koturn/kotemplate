#!/usr/bin/env lua

if ... then
  module(..., package.seeall)
end


function split(str, delim)
  if string.find(str, delim) == nil then
    return { str }
  end
  local result = {}
  local pat = '(.-)' .. delim .. '()'
  local lastPos
  for part, pos in string.gfind(str, pat) do
    table.insert(result, part)
    lastPos = pos
  end
  table.insert(result, string.sub(str, lastPos))
  return result
end


if not ... then
  line = io.read()
  while line do
    tokens = split(line, ' +')
    <+CURSOR+>

    line = io.read()
  end
end
