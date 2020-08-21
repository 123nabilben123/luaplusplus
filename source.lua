
local memory = {
		indentation = 0
}

local currentStatements = {
	
}

--print('This is red-> \27[31mred\n')
local exeucting = true;

local lexxing = {
		["print"] = function (completeString)
				print (completeString)
		end,

		["DEFINE"] = function (UnusedArgument, NameAndValue)
				-- split the NameAndValue into the name and the value
				local array = {}
				local name;
				local value;

				for c in string.gmatch(NameAndValue, "[^%s]+") do
						if name == nil then
								name = c
						elseif value == nil then
								if tonumber(c) then
										value = tonumber(c)
								else
										value = c
								end
						end
				end

				memory[name] = value
				print(memory[name])
		end,

		["INDENT"] = function(UnusedArgument, NameAndValue)
				memory.indentation = memory.indentation + 1
		end,

		["DEDENT"] = function(UnusedArgument, NameAndValue)
				if memory.indentation > 0 then
						memory.indentation = memory.indentation - 1
				end
		end	
}

local function TakeInInputAndFilter(statement) -- filters key points in the statement, e.g (the CONSTRUCTOR, the value, the name) and then calls the constructor with values needed.

		local constructor;

		for token in string.gmatch(statement, "[^%s]+") do  -- SPLIT BY SPACES (TURN THEM INTO PURE WORDS)
  			--check if a lex exists
				if lexxing[token] ~= nil then
						constructor = token  -- only assigning it the constructor of the statement's change e.g: print Hello World! --> print
						break;
				end
		end	

		-- take the statement, then remove the constructor from that whole string
		local StatementWithOutConstructor = string.gsub(statement, constructor, "") -- REMOVE THE CONSTRUCTOR FROM THE ENTIRE STATEMENT
		local NameAndValue = string.gsub(StatementWithOutConstructor, "=", "") -- remove any operators.

		-- call the function that the string associates with and input whatever is in the string
		local func = lexxing[constructor]
		func(StatementWithOutConstructor, NameAndValue)

		-- recurse back to input another statement
		programmingLanguage()
end


local function TakeInInputAndFilterValues(statement)
		for word in string.gmatch(s, "[^%s]+") do
				if lexxing[word] == nil and memory[word] == nil then
						if tonumber(word) then
								return tonumber(word)
						elseif word == "true" then
								return true
						elseif word == "false" then
								return false
						end
				end
		end
end

function programmingLanguage()
		local userInput = io.read()

		-- log whatever the user types when they press "enter" to easily get the whole programming statement by statement
		table.insert(currentStatements, userInput)
		

		os.execute("clear")

		-- Loop through  all the statements and loop through each one to display the text color of each word and delete any pre-existing code to get a refreshed version
		local indent_space = ""

		for i = 0, memory.indentation do
				indent_space = indent_space .. " "
		end



		if #currentStatements ~= 0 then
			for i,s in pairs(currentStatements) do
						print() -- for next line use
						for token in string.gmatch(s, "[^%s]+") do
								if lexxing[token] then
										io.write("\27[31m\ ")
										io.write(indent_space..token)
								elseif memory[token] then
										io.write("\27[33m\ ")
										io.write(indent_space..token .. " in memory")
								else
										io.write("\27[30m\ ")
										io.write(indent_space..token)
								end
						end
				end
		end

		print() -- for next line use
		if exeucting then
				TakeInInputAndFilter(userInput)
		else
				
				programmingLanguage()
		end
end

programmingLanguage()

 
