xllify.ExcelFunction({
    name = "xllify.Demo.Hello",
    description = "Says hello!",
    category = "xllify Demos",
    parameters = {
        {name="name", description="Name to greet"},
    },
}, function(name: string)
    name = name or "World"
    return "Hello there, " .. name .. "!"
end)

xllify.ExcelFunction({
    name = "xllify.Demo.AgeCategory",
    description = "Determines your life stage based on age",
    category = "xllify Demos",
    parameters = {
        {name="age", description="Age in years"},
    },
}, function(age: number)
    if age < 0 then
        return "Baby"
    elseif age < 13 then
        return "Kid"
    elseif age < 20 then
        return "Annoying teenager"
    elseif age < 65 then
        return "Disillusioned adult"
    else
        return "OK boomer"
    end
end)
