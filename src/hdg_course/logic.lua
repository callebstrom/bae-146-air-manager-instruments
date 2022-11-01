--      BAe-146 Course Splitter    --
-------------------------------------


local TRIANGLE_WIDTH = 35;
local HALF_TRIANGLE_WIDTH =  TRIANGLE_WIDTH / 2
local TRIANGLE_MARGIN_LEFT = 55;

function print_absolute_number(item_nr)
  if item_nr < 0 then
    return "" .. 10 + item_nr
  else
    return "" .. item_nr
  end
end

canvas_id = canvas_add(0, 0, 953, 540, function()
  _rect(0, 0, 883, 695)
  _fill("#111111")
end)

local nav1_dig1_text = running_txt_add_ver(390 - 240, 84, 3, 50, 73, print_absolute_number,
  "size:80; color: white; halign: left;")
local nav1_dig2_text = running_txt_add_ver(452 - 245, 84, 3, 50, 73, print_absolute_number,
  "size:80; color: white; halign: left;")
local nav1_dig3_text = running_txt_add_ver(512 - 250, 84, 3, 50, 73, print_absolute_number,
  "size:80; color: white; halign: left;")
  
local nav2_dig1_text = running_txt_add_ver(390 + 255, 84, 3, 50, 73, print_absolute_number,
  "size:80; color: white; halign: left;")
local nav2_dig2_text = running_txt_add_ver(452 + 250, 84, 3, 50, 73, print_absolute_number,
  "size:80; color: white; halign: left;")
local nav2_dig3_text = running_txt_add_ver(512 + 245, 84, 3, 50, 73, print_absolute_number,
  "size:80; color: white; halign: left;")

img_add_fullscreen("background.png")
local img_split_knob = img_add("split_knob.png", 383, 105, 175, 175)
local img_nav1_knob = img_add("knob.png", 160, 325, 120, 120)
local img_nav2_knob = img_add("knob.png", 655, 325, 125, 125)
local img_hdg_knob = img_add("hdg_knob.png", 425, 405, 95, 95)

local last_knob_value = {};

function clamp(x, min, max)
    if x >= min then
        if x <= max then return x end
        return max
    end
    return min
end

function create_on_knob_scroll(variable, image, min, max)
    last_knob_value[variable] = 0;
    return function(direction)
      if direction == -1 then
        local new_value = last_knob_value[variable] + 1;
        last_knob_value[variable] = min and max and clamp(new_value, min, max) or new_value;  
        if (image) then rotate(image, last_knob_value[variable] * 10); end
        fs2020_variable_write(variable, "Number", last_knob_value[variable])
      end
    
      if direction == 1 then
        local new_value = last_knob_value[variable] - 1;
        last_knob_value[variable] = min and max and clamp(new_value, min, max) or new_value;  
        if (image) then rotate(image, last_knob_value[variable] * 10); end
        fs2020_variable_write(variable, "Number", last_knob_value[variable])
      end
    end
end

scrollwheel_add_ver(nil, 380, 100, 200, 200, 200, 200, create_on_knob_scroll("L:MCP_NAV_split", nil, 0, 2))
scrollwheel_add_ver(nil, 160, 330, 125, 125, 125, 125, create_on_knob_scroll("L:MCP_NAV1_sel", img_nav1_knob))
scrollwheel_add_ver(nil, 655, 330, 125, 125, 125, 125, create_on_knob_scroll("L:MCP_NAV2_sel", img_nav2_knob))
scrollwheel_add_ver(nil, 425, 405, 95, 95, 95, 95, create_on_knob_scroll("L:MCP_HDG_sel", img_hdg_knob))

function rotate_split_knob(knob)
  if (knob == 0) then
    rotate(img_split_knob, -56, "LINEAR", 1);
  elseif (knob == 1) then
    rotate(img_split_knob, 0, "LINEAR", 1);
  elseif (knob == 2) then
    rotate(img_split_knob, 51, "LINEAR", 1);
  end
end

function update(nav1_dig1, nav1_dig2, nav1_dig3, nav1_sel, nav2_dig1, nav2_dig2, nav2_dig3, split_knob)
  local nav1_dig1_cap = var_cap(nav1_dig1, 0, 9);
  local nav1_dig2_cap = var_cap(nav1_dig2, 0, 9);
  local nav1_dig3_cap = var_cap(nav1_dig3, 0, 9);
  
  last_knob_value["L:MCP_NAV1_sel"] = nav1_sel;
  
  local nav2_dig1_cap = var_cap(nav2_dig1, 0, 9);
  local nav2_dig2_cap = var_cap(nav2_dig2, 0, 9);
  local nav2_dig3_cap = var_cap(nav2_dig3, 0, 9);

  running_txt_move_carot(nav1_dig1_text, nav1_dig1_cap)
  running_txt_move_carot(nav1_dig2_text, nav1_dig2_cap)
  running_txt_move_carot(nav1_dig3_text, nav1_dig3_cap)
  
  running_txt_move_carot(nav2_dig1_text, nav2_dig1_cap)
  running_txt_move_carot(nav2_dig2_text, nav2_dig2_cap)
  running_txt_move_carot(nav2_dig3_text, nav2_dig3_cap)

  rotate_split_knob(split_knob);
end

fs2020_variable_subscribe(
  "L:MCP_NAV1_dig1", "Number",
  "L:MCP_NAV1_dig2", "Number",
  "L:MCP_NAV1_dig3", "Number",
  "L:MCP_NAV1_sel", "Number",
  "L:MCP_NAV2_dig1", "Number",
  "L:MCP_NAV2_dig2", "Number",
  "L:MCP_NAV2_dig3", "Number",
  "L:MCP_NAV_split", "Number",
  update)

