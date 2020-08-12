_addon.name = 'Trustworthy'
_addon.version = '0.1'
_addon.author = 'Omnys@Valefor'
_addon.commands = {'trustworthy','tw'}
 
res = require('resources')
require('logger')
 
spells = res.spells
trusts = S(res.spells:type('Trust'):map(table.get-{'name'}))
MyTrusts = {}
known = {}
 
function establishTrusts()
    known = windower.ffxi.get_spells()
 
    MyTrusts = T{}
    for k, v in pairs(known) do
        if spells[k] and spells[k].type == "Trust"  then 
            MyTrusts[string.lower(spells[k].english)] = v
        end
    end
end
establishTrusts()
 
windower.register_event('zone change',function()
    -- Get Trust list again in case ciphers were learned, makes searches accurate
    establishTrusts:schedule(10)
end)
 
windower.register_event('addon command', function(...)
    local args = T{...}:map(string.lower)
    local cmd = table.concat(args," ")
    if args[1] == nil or args[1] == "help" then
        log("Type //tw [partial trust name]")
    elseif (args[1] == "find" or args[1] == "search") and #args > 1 then
        cmd = windower.regex.replace(cmd,"^"..args[1].." ","")
        log("Trusts matching '"..cmd.."'.")
        for k, v in pairs(MyTrusts) do
            if string.find(k,string.lower(cmd)) then
                if v then
                    windower.add_to_chat(255,"    You already have "..string.upper(k)..".")
                else
                    windower.add_to_chat(167,"    You do not have "..string.upper(k)..".")
                end
            end
        end
    end
end)

