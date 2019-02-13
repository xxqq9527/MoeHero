local runtime	= require 'jass.runtime'
local console	= require 'jass.console'

base = {}

--判断是否是发布版本
base.release = not pcall(require, 'lua.currentpath')

--版本号
base.version = '4.18'

--打开控制台
if not base.release then
	console.enable = true
end

--重载print,自动转换编码
print = console.write

--将句柄等级设置为0(地图中所有的句柄均使用table封装)
runtime.handle_level = 0

--关闭等待
runtime.sleep = false

--调试器端口
runtime.debugger = 4279

function base.error_handle(msg)
	print("---------------------------------------")
	print(tostring(msg) .. "\n")
	print(debug.traceback())
	print("---------------------------------------")
end

--错误汇报
function runtime.error_handle(msg)
	base.error_handle(msg)
end

local function tryDebugger()
	local dbg = require 'debugger'
	dbg:io 'listen:127.0.0.1:4279'
	dbg:start()
	print('Debugger startup, listen port: 4279')
end

--测试版本和发布版本的脚本路径
if base.release then
	package.path = package.path .. [[;Poi\]] .. base.version .. [[\?.lua;scripts\?.lua]]
end

if not base.release then
	pcall(tryDebugger)
end

--初始化本地脚本
require 'main'
