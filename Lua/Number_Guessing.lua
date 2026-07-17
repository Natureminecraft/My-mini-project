-- Functions
local function ask_max_number()
	while true do
		io.write("What is the highest number you want? : ")
		local ans = tonumber(io.read())
		if ans then
			return math.abs(math.ceil(ans))
		else
			print("Sorry please try again.\n")
		end
	end
end

local function guessNum(num, maxnum)
	while true do
		io.write("Guess the number beetween 1-" .. maxnum .. ": ")
		local guess = tonumber(io.read())
		if guess then
			guess = math.ceil(guess)
			if guess == num then
				print("Correct. You Win!")
				return
			elseif guess < 1 or guess > maxnum then
				print("The number is between 1-" .. maxnum .. ".\n")
			elseif guess > num then
				print("Too High\n")
			elseif guess < num then
				print("Too low\n")
			end
		else
			print("Sorry please try again.\n")
		end
	end
end

--An actual code
local maxnum = ask_max_number()
local num = math.random(1, maxnum)

guessNum(num, maxnum)
