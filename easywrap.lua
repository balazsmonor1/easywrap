local http = require("coro-http")
function writefile(file,content)
    open = io.open(file, "w")
    open:write(content)
    open:close()
end
function readfile(file)
    local open = io.open(file, "r")
    local thing = open:read("*all")
    open:close()
    return thing
end
function appendfile(file,content)
    local old_content = readfile(file)
    writefile(file,old_content..""..content)
end
function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end
function http_request(tbl)
    local result,grab = http.request(tbl.Method,tbl.Url,tbl.Headers,tbl.Body)
    local Cookies = {}
    for _,v in pairs(result) do
        if type(v) == "table" and v[1]:lower() == "set-cookie" then
            table.insert(Cookies,v[2])
        end
    end
    return {result = result,Cookies = Cookies, Body = grab}
end
function get_input(txt)
    io.write(txt.." > ")
    local option
    repeat option = io.read() until type(option) == "string" and option:match("%S")
    return option
end
function starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end
function split_date(date)
  -- YYYY-MM-DD HH-MM-SS
  local year_time = split(date, " ")
  local year_uf = year_time[1]
  local time_uf = year_time[2]
  --year shit
  local year_month_day = split(year_uf,"-")
  local year = year_month_day[1]
  local month = year_month_day[2]
  local day = year_month_day[3]
  -- time shit
  local hour_min_sec = split(time_uf,":")
  local hour = hour_min_sec[1]
  local min = hour_min_sec[2]
  local sec = hour_min_sec[3]
  local seconds_total = 0
  seconds_total = seconds_total + (year * 31536000)
  seconds_total = seconds_total + (month * 2628002)
  seconds_total = seconds_total + (day * 86400)
  seconds_total = seconds_total + (hour * 3600)
  seconds_total = seconds_total + (min * 60)
  seconds_total = seconds_total + sec
  return seconds_total
end
function order_date(dates)
  local cached_dates = {}
  for i,v in pairs(dates) do
    local seconds_total = split_date(v)    
    table.insert(cached_dates,seconds_total)
  end
  return cached_dates 
end
function hex_to_rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end
return {
  writefile = writefile,
  readfile = readfile,
  appendfile = appendfile,
  http_request = http_request,
  get_input = get_input,
  split = split,
  starts = starts,
  split_date = split_date,
  order_date = order_date,
  hex_to_rgb = hex_to_rgb
}
