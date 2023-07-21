local parser = {}

function parser.parse_initial(state_str)
    return load("return " .. state_str)()
end

function parser.parse_rule(decimal)
    local binary = {}
    while decimal > 0 do
        table.insert(binary, decimal%2)
        decimal = math.floor(decimal/2)
    end
    return binary
end

return parser