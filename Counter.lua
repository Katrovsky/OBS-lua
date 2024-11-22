obs = obslua
counter_value = 0

-- Specify the exact name of the "Text (GDI+)" source here
-- Укажите точное имя источника "Текст (GDI+)" здесь
source_name = "Counter"

-- This script modifies only the number after the last space in the text
-- Скрипт изменяет только число после последнего пробела в строке

hotkey_add = obs.OBS_INVALID_HOTKEY_ID
hotkey_subtract = obs.OBS_INVALID_HOTKEY_ID
hotkey_reset = obs.OBS_INVALID_HOTKEY_ID

function update_counter()
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        local settings = obs.obs_source_get_settings(source)
        local current_text = obs.obs_data_get_string(settings, "text")
        local new_text = current_text:match("^(.*%s)%d+$") or "" -- Keep the text before the number
        new_text = new_text .. tostring(counter_value) -- Append the updated number
        obs.obs_data_set_string(settings, "text", new_text)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    end
end

function add_to_counter(pressed)
    if not pressed then return end
    counter_value = counter_value + 1
    update_counter()
end

function subtract_from_counter(pressed)
    if not pressed then return end
    counter_value = math.max(counter_value - 1, 0)
    update_counter()
end

function reset_counter(pressed)
    if not pressed then return end
    counter_value = 0
    update_counter()
end

function script_description()
    return [[
A script to manage a customizable counter with Add, Subtract, and Reset functionality in OBS.

Instructions:
1. Create a "Text (GDI+)" source in OBS and name it (e.g., "Counter").
2. Update the `source_name` variable in the script with the exact name of the "Text (GDI+)" source.
3. Ensure the text in the source ends with a number after a space (e.g., "Counter: 0").
4. Set hotkeys for the actions:
   - "Add to Counter" to increase the counter by 1.
   - "Subtract from Counter" to decrease the counter by 1 (minimum is 0).
   - "Reset Counter" to reset the counter to 0.
5. Use the configured hotkeys during your stream to update the counter in real time.
]]
end

function script_properties()
    return obs.obs_properties_create()
end

function script_load(settings)
    hotkey_add = obs.obs_hotkey_register_frontend("add_to_counter", "Add to Counter", add_to_counter)
    hotkey_subtract = obs.obs_hotkey_register_frontend("subtract_from_counter", "Subtract from Counter", subtract_from_counter)
    hotkey_reset = obs.obs_hotkey_register_frontend("reset_counter", "Reset Counter", reset_counter)

    local hotkey_add_saved = obs.obs_data_get_array(settings, "hotkey_add")
    obs.obs_hotkey_load(hotkey_add, hotkey_add_saved)
    obs.obs_data_array_release(hotkey_add_saved)

    local hotkey_subtract_saved = obs.obs_data_get_array(settings, "hotkey_subtract")
    obs.obs_hotkey_load(hotkey_subtract, hotkey_subtract_saved)
    obs.obs_data_array_release(hotkey_subtract_saved)

    local hotkey_reset_saved = obs.obs_data_get_array(settings, "hotkey_reset")
    obs.obs_hotkey_load(hotkey_reset, hotkey_reset_saved)
    obs.obs_data_array_release(hotkey_reset_saved)
end

function script_save(settings)
    local hotkey_add_saved = obs.obs_hotkey_save(hotkey_add)
    obs.obs_data_set_array(settings, "hotkey_add", hotkey_add_saved)
    obs.obs_data_array_release(hotkey_add_saved)

    local hotkey_subtract_saved = obs.obs_hotkey_save(hotkey_subtract)
    obs.obs_data_set_array(settings, "hotkey_subtract", hotkey_subtract_saved)
    obs.obs_data_array_release(hotkey_subtract_saved)

    local hotkey_reset_saved = obs.obs_hotkey_save(hotkey_reset)
    obs.obs_data_set_array(settings, "hotkey_reset", hotkey_reset_saved)
    obs.obs_data_array_release(hotkey_reset_saved)
end