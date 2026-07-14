--Function
local function check_table(check, table)
    for _, value in ipairs(table) do
        if check == value then
            return(true)
        end
    end
end

local function ask_yes_or_no()
    while true do
        io.write("Roll the dice? (Y, N): ")
        local ans = io.read()
        local yes = {"y","Y"}
        local no = {"n","N"}
        if check_table(ans,yes) then
            print()
            return(true)
        elseif check_table(ans,no) then
            print()
            return(false)
        else
            print("Sorry please try again.\n")
        end
    end
end

local function ask_how_much()
    while true do
        io.write("How much dice do you want to roll? : ")
        local amount = io.read()
        amount = tonumber(amount)
        if amount then
            return(amount)
        else
            print("Sorry please try again.\n")
        end
    end
end

local function gambling(amount)
    local total = ""
    for _=1, amount do
        total = total .. tostring(math.random(1,6)) .. " "
    end
    return(total)
end

if ask_yes_or_no() then
    print(gambling(ask_how_much()))
end