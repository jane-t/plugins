require 'lfs'
require 'luacom'

if ... == nil then error("\n\nThis is a Library Module, and so it can not be executed on its own.    ") end
module(..., package.seeall)

function fhhutils.loadrequire(module,extended)
    if not(extended) then extended = module end
    local function installmodule(module,filename)
        local bmodule = false
        if not(filename) then
            filename = module..'.mod'
            bmodule = true
        end
        local storein = fhGetContextInfo('CI_APP_DATA_FOLDER')..'\\Plugins\\'
        -- Check if subdirectory needed
        local path = string.match(filename, "(.-)[^/]-[^%.]+$")
        if path ~= "" then
            path = path:gsub('/','\\')
            -- Create sub-directory
            lfs.mkdir(storein..path)
        end
        -- Get file down and install it
        local http = luacom.CreateObject("winhttp.winhttprequest.5.1")
        local url = "http://www.family-historian.co.uk/lnk/getpluginmodule.php?file="..filename
        http:Open("GET",url,false)
        http:Send()
        http:WaitForResponse(30)
        local status = http.StatusText
        if status == 'OK' then
            length = http:GetResponseHeader('Content-Length')
            data = http.ResponseBody
            if bmodule then
                local modlist = loadstring(http.ResponseBody)
                for _,f in pairs(modlist()) do
                    if not(installmodule(module,f)) then
                        break
                    end
                end
            else
                local function OpenFile(strFileName,strMode)
                    local fileHandle, strError = io.open(strFileName,strMode)
                    if not fileHandle then
                        error("\n Unable to open file in \""..strMode.."\" mode. \n "..
                                strFileName.." \n "..tostring(strError).." \n")
                    end
                    return fileHandle
                end -- OpenFile
                local function SaveStringToFile(strString,strFileName)
                    local fileHandle = OpenFile(strFileName,"wb")
                    fileHandle:write(strString)
                    assert(fileHandle:close())
                end -- SaveStringToFile
                SaveStringToFile(data,storein..filename)
            end
            return true
        else
            fhMessageBox('An error occurred in Download please try later')
            return false
        end
    end
    local function requiref(module)
        require(module)
    end
    res = pcall(requiref,extended)
    if not(res) then
        local ans = fhMessageBox(
        'This plugin requires '..module..' support, please click OK to download and install the module',
        'MB_OKCANCEL','MB_ICONEXCLAMATION')
        if ans ~= 'OK' then
            return false
        end
        if installmodule(module) then
            package.loaded[extended] = nil  -- Reset Failed Load
            require(extended)
        else
            return false
        end
    end
    return true
end
return (fhhutils)