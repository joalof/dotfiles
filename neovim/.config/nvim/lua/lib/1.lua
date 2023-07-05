local t = {{1, 2}, nil}

for _, tt in ipairs(t) do
    if tt then
        vim.pretty_print(tt)
    end
end
    
