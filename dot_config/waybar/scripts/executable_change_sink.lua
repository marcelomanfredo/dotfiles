local json = require("cjson")

-- Patterns for identifying the correct inputs
local SPEAKER = "Built%-in"
local HEADPHONE = "HyperX"

local should_split = false

local apps = {}
local apps_count = 0

local function get_stdout(cmd)
	local f = assert(io.popen(cmd))
	local data = f:read("*a")
	f:close()
	return data
end

local function get_sinks()
	local data = get_stdout("pactl --format=json list sinks")
	return json.decode(data)
end

local function get_sink_inputs()
	local data = get_stdout("pactl --format=json list sink-inputs")
	return json.decode(data)
end

local function get_default_sink()
	return get_stdout("pactl get-default-sink")
end

local function set_default_sink(target)
	return os.execute("pactl set-default-sink " .. target)
end

local function move_sink(index, sink)
	return os.execute("pactl move-sink-input " .. index .. " " .. sink)
end

local function apps_running()
	local inputs = get_sink_inputs()
	for _, input in pairs(inputs) do
		local bin = input.properties["application.process.binary"]
		if bin then
			apps[input.index] = bin
		end
	end
end

local function init()
	apps_running()
	local firefox = false
	local other = false
	for _, k in pairs(apps) do
		apps_count = apps_count + 1
		if k == "firefox" then
			firefox = true
		elseif k then
			other = true
		end
	end
	print(apps_count, firefox, other, should_split)
	if apps_count > 1 and firefox and other then
		should_split = true
	end
end

local function main()
	-- The idea is to check if firefox and something else is running.
	-- If so, set default to headset and move firefox to speaker
	init()
	-- Case firefox and something else is running
	if should_split and arg[1] == "split" then
		local sinks = get_sinks()
		local default = get_default_sink()

		local speaker = default
		local headphone = default
		for _, sink in pairs(sinks) do
			if string.match(sink.description, SPEAKER) then
				speaker = sink.index
			elseif string.match(sink.description, HEADPHONE) then
				headphone = sink.index
			end
		end

		set_default_sink(headphone)
		for i, k in pairs(apps) do
			if k == "firefox" then
				move_sink(i, speaker)
			end
		end
	-- By default, set everything to the default so everything works fine
	elseif arg[1] == "restore" then
		local default = get_default_sink()

		for i, _ in pairs(apps) do
			move_sink(i, default)
		end
	end
end

os.exit(main())
