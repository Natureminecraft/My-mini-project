-- Help working with tables easier
local function check_table(table, find)
  for _, value in ipairs(table) do
    if value == find then
      return true
    end
  end
  return false
end

local function clear_data(check, items)
  for index, value in pairs(check) do
    if value then
      for i, _ in ipairs(items) do
        if items[i] == index then
          table.remove(items, i)
        end
      end
      check[index] = nil
    end
  end
  return check, items
end

-- Set to raw mode
local function set_raw_mode(enable)
  if enable then
    os.execute("stty raw -echo")
  else
    os.execute("stty sane")
  end
end

-- Clear the screen
local function clear_screen()
  io.write("\27[2J\27[H")
end

-- Select the position you want to write something
local function set_writing_position(row, col)
  io.write(string.format("\27[%d;%dH", row, col))
end

-- Read keyboard input
local function read_input()
  local c = io.read(1)
  if c == "\27" then
    local c2 = io.read(1)
    local c3 = io.read(1)
    if c2 == "[" then
      if c3 == "A" then return "up" end
      if c3 == "B" then return "down" end
    end
    return "esc"
  elseif c == "\r" or c == "\n" then
    return "enter"
  elseif c == "q" then
    return "quit"
  elseif c == "a" then
    return "add"
  elseif c == "r" then
    return "rename"
  elseif c == "d" then
    return "delete"
  elseif c == "c" then
    return "clear"
  end
  return c
end

-- Create Menu
local function draw_menu(items, check, selected)
  clear_screen()
  set_writing_position(1, 1)
  io.write("============ Tasks list ============\n\r\n\r")
  if #items ~= 0 then
    for i, item in ipairs(items) do
      local check_box
      if next(check) ~= nil then
        if check[item] then
          check_box = "󰄳"
        else
          check_box = "󰅙"
        end
      end
      if i == selected then
        io.write(string.format("\27[7m" .. "%s \27[0m\n\r", check_box .. " " .. item .. "    <-"))
      else
        io.write(string.format("%s\n\r", check_box .. " " .. item))
      end
    end
    io.write("\n\r a to add, d to delete, r to rename, c to clear\n\n\r q to quit \n\r")
  else
    io.write("\n\r You have no tasks left. Press a to create new. \r\n")
  end
end

-- Ask
local function ask(prompt)
  set_writing_position(20, 1)
  io.write("\27[K")
  io.write(prompt)
  io.flush()

  local input = ""
  while true do
    local c = io.read(1)

    if c == "\r" or c == "\n" then
      break -- Enter pressed, done
    elseif c == "\127" or c == "\8" then
      -- Backspace (DEL is 127, BS is 8 depending on terminal)
      if #input > 0 then
        input = input:sub(1, -2)
        io.write("\8 \8") -- move back, erase char, move back again
        io.flush()
      end
    elseif c == "\27" then
      -- Ignore
    else
      input = input .. c
      io.write(c) -- echo the character manually
      io.flush()
    end
  end

  return input
end

local function main()
  local items = {}
  local check = {}
  local selected = 1

  set_raw_mode(true)
  draw_menu(items, check, selected)

  while true do
    local key = read_input()
    if key == "up" then
      selected = selected - 1
      if selected < 1 then selected = #items end
    elseif key == "down" then
      selected = selected + 1
      if selected > #items then selected = 1 end
    elseif key == "enter" then
      if #items ~= 0 then
        local status = check[items[selected]]
        if status then
          status = false
        else
          status = true
        end
        check[items[selected]] = status
      end
    elseif key == "quit" then
      break
    elseif key == "add" then
      local add = ask("Add a Task: ")
      local exist = check_table(items, add)
      if not exist then
        check[add] = false
        table.insert(items, add)
      end
    elseif key == "rename" then
      if #items ~= 0 then
        local rename = ask("Rename a Task: ")
        check[rename] = check[items[selected]]
        check[items[selected]] = nil
        items[selected] = rename
      end
    elseif key == "delete" then
      if #items ~= 0 then
        local yes = { "y", "Y" }
        local answer = ask("Are you sure you want to remove the task? (y/n): ")
        local confirm = check_table(yes, answer)
        if confirm then
          check[items[selected]] = nil
          table.remove(items, selected)
          if selected ~= 1 then
            selected = selected - 1
          end
        end
      end
    elseif key == "clear" then
      local answer = ask("Are you sure you want to clear the task? (y/n): ")
      if answer then
        check, items = clear_data(check, items)
      end
    end
    draw_menu(items, check, selected)
  end

  set_raw_mode(false)
  clear_screen()
  print("Tasks list by Nature.")
end

-- Code
main()
