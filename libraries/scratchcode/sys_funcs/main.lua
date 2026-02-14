local main_func = {}

function main_func.require(args)
    local returned_func_table = require("libraries.scratchcode.sys_funcs."..to_string(args[1]))

    if returned_func_table and to_string(args[1]) ~= "main" and to_string(args[1]) ~= "builtin" then
        for key ,val in pairs(returned_func_table) do
            print("Exporting module function "..tostring(key))

            _G.func_table[key] = val
        end
    else
        print("Sorry, but the module doesn`t exist or isn`t valid...")
    end
end

return main_func