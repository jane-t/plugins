if ... == nil then error('This is a Module') end
module(..., package.seeall)
-- Split a string using "," or chosen separator --
function fhhstring.split(strTxt,strSep)
	local strSep = strSep or ","
	local tblFields = {}
	local strPattern = string.format("([^%s]+)", strSep)
	strTxt = strTxt or ""
	strTxt:gsub(strPattern, function(strField) tblFields[#tblFields+1] = strField end)
	return tblFields
end -- function string.split

function fhhstring.gedsplit(strTxt)
   local  level,key,value = gline:match('(.-) (.-) (.+)')
   if level == nil then
      level,key = gline:match('(.-) (.+)')
   end
	return level,key,value
end -- function fhhstring.gedsplit

function fhhstring.splitfilename(strfilename)
	-- Returns the Path, Filename, and Extension as 4 values
   -- Path, Filename with Extension, Filename, Extension
	return string.match(strfilename, "(.-)(([^\\]-)%.([^\\%.]+))$")
end

-- Split a string into numbers using " " or "," or "x" separators	-- Any non-number remains as a string
function fhhstring.splitnumbers(strTxt)
	local tblNum = {}
	strTxt = strTxt or ""
	strTxt:gsub("([^ ,x]+)", function(strNum) tblNum[#tblNum+1] = tonumber(strNum) or strNum end)
	return tblNum
end -- function string.splitnumbers

-- Hide magic pattern symbols	^ $ ( ) % . [ ] * + - ?
function fhhstring.plain(strTxt)
	-- Prefix every non-alphanumeric character (%W) with a % escape character,
	-- where %% is the % escape, and %1 is the original character capture.
	strTxt = (strTxt or ""):gsub("(%W)","%%%1")
	return strTxt
end -- function string.plain

-- fhhstring.matches is plain text version of string.match()
function fhhstring.matches(strTxt,strFind,intInit)
	strFind = (strFind or ""):gsub("(%W)","%%%1")						-- Hide magic pattern symbols
	return strTxt:match(strFind,intInit)
end -- function string.matches

-- fhhstring.replace is plain text version of string.gsub()
function fhhstring.replace(strTxt,strOld,strNew,intNum)
	strOld = (strOld or ""):gsub("(%W)","%%%1")							-- Hide magic pattern symbols
	return strTxt:gsub(strOld,function() return strNew end,intNum)	-- Hide % capture symbols
end -- function string.replace


-- fhhstring.convert is pattern without captures version of string.gsub()
function fhhstring.convert(strTxt,strOld,strNew,intNum)
	return strTxt:gsub(strOld,function() return strNew end,intNum)	-- Hide % capture symbols
end -- function string.convert

-- fhhstring.trim remove leading and trailing whitespace
function fhhstring.trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- fhh.startswith checks if string starts with provided string
function fhhstring.startswith(s,v)
return string.sub(s,1,string.len(v))==v
end
function fhhstring.endswith(s,v)
return string.sub(s,(-1 * string.len(v)))==v
end

function fhhstring.titlecase(s)
local function tchelper(first, rest)
  return first:upper()..rest:lower()
end
  local s = s:gsub("(%a)([%w_']*)", tchelper) 
return(s)
end
-- fhhstring.import  overload fhhstring into string
function fhhstring.import()
   for k,v in pairs(fhhstring) do
     if k ~= 'import' and k ~= 'version' then
     string[k] = v
     end
   end
end

function fhhstring.version(sFormat)    
   if type(sFormat) == 'string' and sFormat:lower() == 'text' then
     return '1.0' 
   else
     return '001000' 
   end
end

return(fhhstring)