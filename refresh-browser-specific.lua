obs = obslua
hotkey_id = obs.OBS_INVALID_HOTKEY_ID

function script_properties()
	local props = obs.obs_properties_create()
    obs.obs_properties_add_button(props,"refresh_browsers","Refresh Browsers",refresh_preview_browsers)
	return props
end

function script_description()
	return "Adds hotkey to refesh the preview browser only"
end


function script_update(settings)

end

function refresh_browsers_trigger(pressed)
	if not pressed then
		return
    end

    refresh_preview_browsers()
end


function refresh_preview_browsers()
	local scenesource = obs.obs_frontend_get_current_preview_scene()
	if scenesource ~= nil then
	    print ("Source Found")
	else
		print ("No Source Found")
		return
	end

	local scene = obs.obs_scene_from_source(scenesource)
	local scene_name = obs.obs_source_get_name(scenesource)
	print("Selected Scene: ")
	print (scene_name)

	local scene_items = obs.obs_scene_enum_items(scene)

    if scene_items ~= nil then
        for _, scene_item in ipairs(scene_items) do
			print("in for loop ")
            local source = obs.obs_sceneitem_get_source(scene_item)
            local source_id = obs.obs_source_get_unversioned_id(source)
			print ("source_id " .. source_id)
			if source_id == "browser_source" then
				print ("refresh browser source")
				local settings = obs.obs_source_get_settings(source)
				local fps = obs.obs_data_get_int(settings, "fps")
				if fps % 2 == 0 then
					obs.obs_data_set_int(settings,"fps",fps + 1)
				else
					obs.obs_data_set_int(settings,"fps",fps - 1)
				end
				obs.obs_source_update(source, settings)
				obs.obs_data_release(settings)
            end
			print ("out of settings change")
        end
    end

	print ("release source")
	obs.obs_source_release(scenesource)
	print ("release sources")
	obs.source_list_release(sources)
end


function script_load(settings)
    hotkey_id = obs.obs_hotkey_register_frontend("refresh_browsers.trigger","Refresh Preview browsers", refresh_browsers_trigger)
    local hotkey_save_array = obs.obs_data_get_array(settings, "refresh_browsers.trigger")
	obs.obs_hotkey_load(hotkey_id, hotkey_save_array)
	obs.obs_data_array_release(hotkey_save_array)
end

function script_save(settings)
	local hotkey_save_array = obs.obs_hotkey_save(hotkey_id)
	obs.obs_data_set_array(settings, "refresh_browsers.trigger", hotkey_save_array)
	obs.obs_data_array_release(hotkey_save_array)
end





