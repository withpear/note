local M = {}

M.deepcopy = function(t)
    if type(t) ~= "table" then
        return t
    end
    local tab = {}
    for k, v in pairs(t) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = M.deepcopy(v)
        end
    end
    return tab
    -- return setmetatable(tab, M.deepcopy(getmetatable(t)))
end
return M
