

--- Slice part of a table and return a new copy
---
--- Note : This methods does not check if tbl is a table, it does not check
---        if first and last are valid... it is the responsibility of the caller
---        to make sure all args are valid.
---
-- @param tbl the table to slice
-- @param first (optional) the starting index (default 1)
-- @param last (optional) the last index (default #tbl)
-- @param step (optinal) skip elements between first...last (default 1)
-- @return table
function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end


--- Return all the keys in the given table. The table is assume not to be
--- an array.
-- @param tbl the table
-- @return table an array of all the keys in the given table
function table.keys(tbl)
  local keys = {};

  for key,val in pairs(tbl) do
    table.insert(keys, key);
  end

  return keys;
end