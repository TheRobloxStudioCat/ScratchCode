local font_size = 18

print([[Welcome to ScratchCode!
Example project made by TheDreamingCat]])

local scr_code = require("libraries.scratchcode.main")

love.window.close()

local function split(input)
    local result = {}

    local current = ""

    local in_quotes = false
    local quote_char = nil

    for i = 1, #input do
        local char = input:sub(i, i)

        if (char == '"' or char == "'") then
            if not in_quotes then
                in_quotes = true

                quote_char = char
            elseif char == quote_char then
                in_quotes = false

                quote_char = nil
            end
            current = current .. char
        elseif char == "&" and not in_quotes then
            table.insert(result, current:match("^%s*(.-)%s*$"))

            current = ""
        else
            current = current .. char
        end
    end

    if current ~= "" then
        table.insert(result, current:match("^%s*(.-)%s*$"))
    end

    return result
end

function love.update()
    io.write("ScrCode> ")

    local run_to = split(io.read())

    scr_code.comp_and_run(run_to)
end