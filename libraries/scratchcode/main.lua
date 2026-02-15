--ScratchCode programming language version 2.0.

--Made by TheDreamingCat on 15th of February,2026
--ScratchCode Codename:Bublik release version

--Very silly code,please be aware.

--Silly is now required.

local ScratchCode = {}

local functions = {}

_G.func_table = require("libraries.scratchcode.function_table")

local function_vars = {}
local function_vars_name = {}

local silly_mode = false --It`s not silly ;(

local log_thread = false

local in_if = false

local variable_name = {}
local variable_value = {}

local forever_stack = {}

local if_stack = {}

current_while_loop = 0

math.randomseed(love.timer.getTime())

local function should_execute() -- Checks if the runtime should execute the current line
    for _, status in ipairs(if_stack) do
        if status == false then return false end
    end
    return true
end

local function find(table,value) -- Finds the specified value in the specified table
    local returned_i = 0

    for i,v in ipairs(table) do
        if v == value then
            returned_i = i

            break
        end
    end

    return returned_i
end

local function is_aVar(name) -- Get if the provided variable name is a variable or a value,returns the value of the variable if its a variable,else returns the provided value
    local variable_lists = {}
    local variable_lists2 = {}

    for i, v in pairs(variable_value) do
        table.insert(variable_lists2,v)
        table.insert(variable_lists,variable_name[i])
    end

    for i, v in pairs(function_vars) do
        table.insert(variable_lists2,v)
        table.insert(variable_lists,function_vars_name[i])
    end

    local returned = find(variable_lists,name)

    --print(variable_lists2[returned],name)

    --print(returned)

    if returned == 0 then
        returned = name
    else
        returned = variable_lists2[returned]
    end

    return returned
end

function newVar(name,value) -- Creates a new variable with the specified name and value.If the variable already exists,changes its value
    local var = find(variable_name,name)

    if var == 0 and name ~= "" then
        table.insert(variable_name,name)
        table.insert(variable_value,value)

        --print("create")
    elseif name ~= "" then
        variable_value[var] = value
    end
end

local function returnVariable(main_str)
    local input_ret = {}

    for add_str in main_str:gmatch("([^%->]+)") do
        local trimmed = add_str:match("^%s*(.-)%s*$")
        table.insert(input_ret, trimmed)
    end

    return #input_ret > 1,input_ret
end

local function syntaxGet(text) -- Self explanitory
    local saved_table = {}
    local saved_value = ""

    local inString = false

    local splitStr = " "

    for i = 1, #text do
        local char = text:sub(i, i)

        -- Toggle string mode
        if char == "'" or char == '"' then
            inString = not inString

            saved_value = saved_value .. char
        elseif char == splitStr and not inString then
            local trimmed = saved_value:match("^%s*(.-)%s*$")

            if trimmed ~= "" then
                table.insert(saved_table, trimmed)
            end
            
            saved_value = ""

            splitStr = ","
        else
            saved_value = saved_value .. char
        end

        if i == #text then
            local trimmed = saved_value:match("^%s*(.-)%s*$")

            if trimmed ~= "" then
                table.insert(saved_table, trimmed)
            end
        end
    end

    return saved_table
end

function to_string(text)
    local returned_string = "none" -- I can change this at any moment.

    if text and tostring(text) == text then
        if text:sub(1,1) == "'" and text:sub(#text,#text) == "'" then
            returned_string = text:sub(2,#text - 1)
        elseif text:sub(1,1) == '"' and text:sub(#text,#text) == '"' then
            returned_string = text:sub(2,#text - 1)
        end

        local randon_chance = math.random(1,10)

        if randon_chance == 6 and silly_mode then -- Not so lucky.
            returned_string = "Srry if this breaks anything,but idc."

            print("Ur lucky ig")
        end
    else
        print("ScrCode>Converting to string..")

        returned_string = tostring(text)

        if not returned_string then
            returned_string = "nil"
        end
    end

    return returned_string
end

local function getMath(string_math)
    local num_p = "(%S+)"
    local op_p = "([%+%-%*/])"

    local n1, op, n2 = string_math:match("^"..num_p.."%s+"..op_p.."%s+"..num_p.."$")

    return (n1 ~= nil and op ~= nil and n2 ~= nil),{n1,op,n2}
end

local function getVarData(string_assign)
    --print(string_assign)

    local var_name, equals_sign, expression = string_assign:match("^(%S+)%s*(=)%s*(.*%S*)%s*$")

    --print(string_assign)
    
    if var_name and equals_sign and expression then
        --print(string_assign)

        --print(true, {var_name, expression})

        return true, {var_name, expression}
    end

    --print(string_assign)
    
    return false, {}
end

local function run_synt(syntax_saved,mainList,index) -- Runs the provided function.
    local isRet,retVariable = returnVariable(tostring(syntax_saved[#syntax_saved]))

    --print(isRet)

    --print(realVal.."|")

    if isRet then
        --print(retVariable[2])

        syntax_saved[#syntax_saved] = retVariable[1]
    end

    --print(syntax_saved[1])

    for i,v in ipairs(syntax_saved) do
            if i > 1 then
                local isOper,ret_oper = getMath(v)

                if isOper then
                    for i,v in ipairs(ret_oper) do
                        if i == 1 or i == 3 then
                            ret_oper[i] = tonumber(is_aVar(v)) or 0
                        end
                    end

                    local mathOperators = {
                        ["+"] = ret_oper[1] + ret_oper[3],
                        ["-"] = ret_oper[1] - ret_oper[3],
                        ["/"] = ret_oper[1] / ret_oper[3],
                        ["*"] = ret_oper[1] * ret_oper[3],
                    }

                    local ret_math = mathOperators[ret_oper[2]]

                    --print(ret_oper[1],ret_oper[2],ret_oper[3])

                    syntax_saved[i] = ret_math
                end
            end
    end

    local saved = syntax_saved[1].." "..(syntax_saved[2] or "")

    --print(saved)

    local isVarCreate,varData = getVarData(saved)

    --print(syntax_saved[2])

    --print(syntax_saved[#syntax_saved])

    --print(saved)

    if syntax_saved[1] == "@if" then
        local condition_result = (is_aVar(syntax_saved[2]) == "true" or true)
        table.insert(if_stack, condition_result)

        return
    elseif syntax_saved[1] == "@endif" then
        table.remove(if_stack)

        return
    elseif syntax_saved[1] == "@forever" then
        table.insert(forever_stack,index)
    
        --print("added ig..")

        --print("Indexing: "..tostring(index))

        return
    elseif syntax_saved[1] == "@endforever" then
        --print("Trying to jump to: "..tostring(forever_stack[#forever_stack]))

        love.timer.sleep(0.001)

        return "jump_ins", forever_stack[#forever_stack]
    end

    --print(saved)

    if should_execute() then
        local function_to_exec = func_table[syntax_saved[1]]

        local returned_syntax = {}

        for _,v in ipairs(syntax_saved) do
            table.insert(returned_syntax,v)
        end

        table.remove(returned_syntax,1)

        --print(syntax_saved[1])

        --print(returned_syntax)

        --print(syntax_saved[1])

        local isFunc = false

        for i,v in pairs(mainList) do
            --print(v[1])

            if v[1] == "@func" and v[2] == syntax_saved[1] then
                isFunc = true
            end
        end

        for i,v in pairs(returned_syntax) do
           returned_syntax[i] = is_aVar(v)
        end

        if function_to_exec then
            local retFunc = function_to_exec(returned_syntax)

            if isRet then
                newVar(retVariable[2],retFunc)

                --print(retVariable[2],retFunc)
            end
        elseif isFunc then
            --print("AWW FUCK YOU")

            get_func(syntax_saved[1],mainList,returned_syntax)
        elseif isVarCreate then
            local isOper,ret_oper = getMath(varData[2])

            if isOper then
                for i,v in ipairs(ret_oper) do
                    if i == 1 or i == 3 then
                        ret_oper[i] = tonumber(is_aVar(v)) or 0
                    end
                end

                local mathOperators = {
                    ["+"] = ret_oper[1] + ret_oper[3],
                    ["-"] = ret_oper[1] - ret_oper[3],
                    ["/"] = ret_oper[1] / ret_oper[3],
                    ["*"] = ret_oper[1] * ret_oper[3],
                }

                local ret_math = mathOperators[ret_oper[2]]

                --print(ret_oper[1],ret_oper[2],ret_oper[3])

                varData[2] = ret_math
            else
                varData[2] = is_aVar(varData[2])
            end

            newVar(varData[1],varData[2])
        elseif syntax_saved[1] ~= "@script" then
            error("Function "..'"'..syntax_saved[1]..'"'.." does not exist.".." Line "..tostring(index))
        end
    end

    --error(saved)
end

local function run_comp(mainList)
    if_stack = {}

    local inFunc = false

    local i = 0

    while i < #mainList do
        i = i + 1

        v = mainList[i]

        local main_chn = love.thread.getChannel("end_channel-"..tostring(thread_id)):peek()

        if main_chn == true then
            break
        end

        if v[1] == "@func" then
            --print('In function,moron!')

            inFunc = true
        elseif v[1] == '@func_end' then
            --print('Not in function,moron!')

            inFunc = false
        else
            if not inFunc then
                local ret,ret_2 = run_synt(v,mainList,i)

                if ret == "jump_ins" then
                    i = ret_2
                end
            end
        end

        --love.timer.sleep(0.001)
    end
end

function compSynt(mainList,compFunc) -- Simple code!
    local ret_table = {}

    local func_saved = {}

    local current_func_pos = {}

    local current_func_name = {}

    local saved_func_cur = {}

    if log_thread then
        --print('Compiling syntax:'..'"'..mainList[1]..'"'..'...')
    end

    for _,v in ipairs(mainList) do
        table.insert(ret_table,syntaxGet(v))
    end

    if log_thread then
        --print('Compiled '..'"'..mainList[1]..'"')
    end

    if compFunc == true then
        for i,v in ipairs(ret_table) do
            if v[1] == "@func" then
                print("Line "..to_string(i))

                table.insert(current_func_name,v[2])
                table.insert(current_func_pos,i)
            elseif v[1] == "@func_end" then
                print("Line "..to_string(i))

                -- print(table_saved[1])

                local compiled_ret = {}

                for i2 = 1,(i - current_func_pos[#current_func_pos]) do
                    local v2 = ret_table[i2 + current_func_pos[#current_func_pos]]

                    table.insert(compiled_ret,v2)
                end

                func_saved[current_func_name[#current_func_name]] = compiled_ret

                table.remove(current_func_name,#current_func_name)

                table.remove(current_func_pos,#current_func_pos)
            end
        end
    end

    if compFunc == true then
        return ret_table,func_saved
    end

    return ret_table
end

function get_func(funcName,mainList,arguments) -- Hardest part...
    for i,v in ipairs(arguments) do
        table.insert(function_vars_name,"var_func_"..i)
        table.insert(function_vars,v)
    end

    local function_got = functions[funcName]

    if function_got then
        run_comp(function_got)
    end

    function_vars = {}
    function_vars_name = {}
end

function ScratchCode.comp_and_run(mainList) -- The most simple function.
    local comp_table,func_table = compSynt(mainList,true)

    functions = func_table

    run_comp(comp_table)
end

function ScratchCode.newthread(mainList,thread_num) -- Also simple.
    --print('Creating thread:'..thread_num)

    local thread_new = love.thread.newThread("libraries/scratchcode/runner.lua")

    thread_new:start(mainList,thread_num)

    return thread_new
end

return ScratchCode

-- "I hate school!" - TheDreamingCat
-- "Roblox got blocked in Russia ;(" - TheDreamingCat
-- "Somehow, this code works." - TheDreamingCat
-- "Very trash code." - Some nerd.
-- "ScratchCode 2.0 is still wip!" - TheDreamingCat
