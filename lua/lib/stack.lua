-- Bubble Up Stack Table
-- Uses a table as stack, use <table>:push(value) and <table>:pop()

-- GLOBAL
BubbleStack = {}

-- Create a Table with stack functions
function BubbleStack:Create()

  -- stack table
  local t = {}
  -- entry table
  t._et = {}

  -- push a value on to the stack or bubble it up
  function t:push_bubble(...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ipairs(targs) do
        for i, p in ipairs(self._et) do
          if p == v then
            table.remove(self._et, i)
          end
        end
        table.insert(self._et, v)
      end
    end
  end


  -- remove
  function t:remove(...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ipairs(targs) do
        for i, p in ipairs(self._et) do
          if p == v then
            table.remove(self._et, i)
          end
        end
      end
    end
  end

  -- get entries
  function t:getn()
    return #self._et
  end


  -- get index
  function t:get_index(bufnr)
    for i, p in ipairs(self._et) do
      if p == bufnr then
        return i
      end
    end
  end

  -- list values
  function t:list()
    for i,v in pairs(self._et) do
      print(i, v)
    end
  end
  return t
end
