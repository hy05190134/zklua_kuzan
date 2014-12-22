require "zklua"
local bit = require("bit")

function zklua_my_watcher(zh, type, state, path, watcherctx)
    if type == zklua.ZOO_SESSION_EVENT then
        if state == zklua.ZOO_CONNECTED_STATE then
            print("Connected to zookeeper service successfully!\n")
        elseif (state == ZOO_EXPIRED_SESSION_STATE) then
            print("Zookeeper session expired!\n")
        end
    end
end

--data why to be the path 
function zklua_create_completion(rc, data)
    if rc == zklua.ZOK then
        print(data .. " create successfully\n")
    elseif rc == zklua.ZNODEEXISTS then
        print("node exists\n")
    else
        print("create " .. data .. "failed\n")
    end
end

function zklua_get_children_watcher(zh, type, state, path, watcherctx)
    print("zklua_my_local_watcher(".."type: "..type..", state: "..state..", path: "..path..")")
    print("zklua_my_local_watcher(".."watcherctx: "..watcherctx..")")
end

function void_completion(rc, value, data)
    if rc == zklua.ZOK then
        print(data)
        if type(value) == "table" then
            for _, v in pairs(value) do
                print(v)
            end
        end
    end
end

zklua.set_log_stream("zklua_kuzan.log")

local zh = zklua.init("127.0.0.1:2181", zklua_my_watcher, 10)

if zh == nil then
    print("zhandle create failed")
    return
end

--read: 1, write: 2, create: 4, delete: 8, admin: 16
local init_acl = {{perms = 31, scheme = "world", id = "anyone"},}

local ipaddr = "127.0.0.1"
local ret = zklua.aget_children(zh, "/cdn/kuzan", 0, void_completion, "get /cdn/kuzan children")


if ret ~= zklua.ZOK then
    print("/cdn/kuzan/server call acreate fail, ret: " .. ret)
    return
end

io.read()
