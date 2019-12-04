 
local OP_Z = 1
local OP_I = 2
local OP_J = 3

local memory = {
  3, -- 1 operand a
  4, -- 2 operand b
  0, -- 3 result
  0, -- 4 accumulator b
  0, -- 5 constant 1
  0  -- 6 constant 0
}

local function dump() 
  for k,v in pairs(memory) do
    print(k..":", v)
  end
end 

local instructions = {
  { "Z", 2 },
  { "I", 2 },
  { "J", 4 }
}

local function sim(code, memory, debug)
  local pc = 1
  local opcode = code[pc]
  local len = #code
  local ic = 0
  print("start program [size: " .. len .. "]")
  while pc < len do
    if debug then
      print("opcode: " .. instructions[opcode][1] .. " pc: " .. pc)
      dump()
    end
    ic = ic + 1
    if opcode == OP_Z then
      local mptr = code[pc+1]
      memory[mptr] = 0
      pc = pc + instructions[OP_Z][2]
    elseif opcode == OP_I then
      local mptr = code[pc+1]
      memory[mptr] = memory[mptr] + 1
      pc = pc + instructions[OP_I][2]
    elseif opcode == OP_J then
      local m1 = code[pc+1]
      local m2 = code[pc+2]
      local v1 = memory[m1]
      local v2 = memory[m2]
      if v1 == v2 then
        pc = pc + instructions[OP_J][2]
      else
        if debug then 
          print("jump to " .. code[pc+3] .. " from " .. pc) end
        pc = code[pc+3]
      end
    end
    opcode = code[pc]
  end
  print("end program [instructions: " .. ic .. "]")
end

--test code

local code = {
  --1:  
  OP_I, 5,
  --3:
  OP_J, 1, 6, 11,
  --7:
  OP_J, 1, 5, 17,
  --11: X
  OP_I, 3,
  --13:
  OP_J, 3, 1, 11,
  --17: W
  OP_J, 2, 6, 25,
  --21:
  OP_J, 2, 5, 33,
  --25: Y
  OP_I, 3,
  --27:
  OP_I, 4,
  --29:
  OP_J, 4, 2, 25,
  --33: Z
  OP_Z, 4,
  --35
  OP_Z, 5
}

local debug = false
sim(code, memory, debug)
dump()
