local OP_Z = 1
local OP_I = 2
local OP_J = 3

local instructions = {
  { "Z", 2 },
  { "I", 2 },
  { "J", 4 }
}

local function sim(code, start, memory)
  local pc = start
  local opcode = code[start]
  local len = #code
  local ic = 0
  print("start program [size: " .. len .. "]")
  while pc < len do
    --print("opcode: " .. instructions[opcode][1] .. " pc: " .. pc)
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
        --print("jump to " .. code[pc+3])
        pc = code[pc+3]
      end
    end
    opcode = code[pc]
  end
  print("end program [instructions: " .. ic .. "]")
end

--test code

local code = {
  OP_Z, 3,
  OP_Z, 4,
  OP_I, 3,
  OP_J, 3, 1, 5,
  OP_I, 3,
  OP_I, 4,
  OP_J, 4, 2, 11,
  OP_Z, 4
}

local memory = {3,4,0,0}

sim(code, 1, memory)
for k,v in pairs(memory) do
  print(k..":", v)
end
