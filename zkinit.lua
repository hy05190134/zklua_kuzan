require "zklua"

function zklua_my_watcher(zh, type, state, path, watcherctx)
    if type == zklua.ZOO_SESSION_EVENT then
        if state == zklua.ZOO_CONNECTED_STATE then
            print("Connected to zookeeper service successfully!\n")
        elseif (state == ZOO_EXPIRED_SESSION_STATE) then
            print("Zookeeper session expired!\n")
        end
    end
end

--date why to be the path 
function zklua_create_completion(rc, value, data)
    if rc == zklua.ZOK then
        print(data .. " create successfully\n")
    elseif rc == zklua.ZNODEEXISTS then
        print(data .. " create exists\n")
    else
        print(data .. " failed\n")
    end
end

function void_completion()

end

zklua.set_log_stream("zklua_init.log")

local zh = zklua.init("127.0.0.1:2181", zklua_my_watcher, 10)

if zh == nil then
    print("zhandle create failed")
    return
end

--read: 1, write: 2, create: 4, delete: 8, admin: 16
local init_acl = {{perms = 31, scheme = "world", id = "anyone"},}

local ret = zklua.acreate(zh, "/cdn", "testcdn", init_acl, 0, zklua_create_completion, "/cdn node")

if ret ~= zklua.ZOK then
    print("/cdn call acreate fail, ret: " .. ret)
    return
end

ret = zklua.acreate(zh, "/cdn/kuzan", "testkuzan", init_acl, 0, zklua_create_completion, "/cdn/kuzan node") 

if ret ~= zklua.ZOK then
    print("/cdn/kuzan call acreate fail, ret: " .. ret)
    return
end

io.read()
