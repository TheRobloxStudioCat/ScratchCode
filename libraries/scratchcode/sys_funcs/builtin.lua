local builtins = {}

function builtins.print(args)
    print(to_string(args[1]))
end

function builtins.warn(args)
    print("Warning:"..to_string(args[1]))
end

function builtins.error(args)
    print(to_string(args[1]))
end

function builtins.wait(args)
    love.timer.sleep(tonumber(args[1]))
end

return builtins