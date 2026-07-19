local dkjson = require("dkjson")

local file = "Items.json" -- Your File here
local yes = { "y", "Y" }

-- Import JSON file
local function import(filename)
  local im_file = io.open(filename, "r")
  if im_file then
    local content = im_file:read("*a")
    im_file:close()
    content = dkjson.decode(content)
    return content
  end
  return {}
end

-- Export JSON file
local function export(filename, table)
  local ex_file = io.open(filename, "w")
  if ex_file then
    local json = dkjson.encode(table, { indent = true })
    ex_file:write(json)
    ex_file:close()
  end
end

-- Check if the input is valid
local function is_valid_input(str)
  return str and string.match(str, "%S") ~= nil
end

-- Help working with tables easier
local function check_table(table, find)
  for _, value in ipairs(table) do
    if value == find then
      return true
    end
  end
  return false
end

-- Clear all finished data
local function clear_data(check, items)
  for i = #items, 1, -1 do
    if check[items[i]] then
      check[items[i]] = nil
      table.remove(items, i)
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
  end
  c = string.lower(c)
  if c == "q" then
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
      local check_box = "󰅙"
      if check[item] then
        check_box = "󰄳"
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
  local check = import(file)
  local selected = 1
  for key, _ in pairs(check) do
    table.insert(items, key)
  end

  set_raw_mode(true)
  draw_menu(items, check, selected)

  while true do
    local key = read_input()
    if key == "up" and #items > 0 then
      selected = selected - 1
      if selected < 1 then selected = #items end
    elseif key == "down" and #items > 0 then
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
        export(file, check)
      end
    elseif key == "quit" then
      break
    elseif key == "add" then
      local add = ask("Add a Task: ")
      if is_valid_input(add) then
        local exist = check_table(items, add)
        if not exist then
          check[add] = false
          table.insert(items, add)
          export(file, check)
        end
      end
    elseif key == "rename" then
      if #items ~= 0 then
        local rename = ask("Rename a Task: ")
        if is_valid_input(rename) then
          if rename ~= items[selected] and not check_table(items, rename) then
            local old_status = check[items[selected]]
            check[items[selected]] = nil
            check[rename] = old_status
            items[selected] = rename
            export(file, check)
          end
        end
      end
    elseif key == "delete" then
      if #items ~= 0 then
        local answer = ask("Are you sure you want to remove the task? (y/n): ")
        local confirm = check_table(yes, answer)
        if confirm then
          check[items[selected]] = nil
          table.remove(items, selected)
          if selected > #items then
            selected = #items
          end
          if selected < 1 then
            selected = 1
          end
          export(file, check)
        end
      end
    elseif key == "clear" then
      local answer = ask("Are you sure you want to clear the task? (y/n): ")
      if check_table(yes, answer) then
        check, items = clear_data(check, items)
        if selected > #items then
          selected = #items
        end
        if selected < 1 then
          selected = 1
        end
      end
      export(file, check)
    end
    draw_menu(items, check, selected)
  end

  set_raw_mode(false)
  clear_screen()
  print("Tasks list by Nature.")
end

-- Code
main()
