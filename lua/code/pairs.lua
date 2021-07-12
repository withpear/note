-- To Rebecca 实现 pairs与ipairs

-- local function mypairs(tbl)
--     return function (state,control)
--         return control,value
--     end,state,control,closing
-- end

local function mypairs(tbl)
    return function(state, control) -- iterator
        control = next(tbl, control)
        local value = tbl[control]
        -- if value == nil then
        --     return nil, nil
        -- end
        return control, value
    end, nil, nil, nil
end

local function myipairs(tbl)
    return function(state, control) -- iterator
        control = control + 1
        local value = tbl[control]
        if value == nil then
            return nil, nil
        end
        return control, value
    end, nil, 0, nil
end

local tb = {aa = "bb", 3, 4, 5}
for key, value in mypairs(tb) do
    print(key, value)
end

local tb1 = {2, 3, 4, 5}
for index, value in myipairs(tb1) do
    print(index, value)
end
