--      BAe-146 Altitde Alerter    --
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

function illuminate_button(color)
    color = "yellow"
    local x = 190;
    local y = 240;
    
    _move_to(x, y)
    local y_boundary = y + TRIANGLE_WIDTH
    _line_to(x + HALF_TRIANGLE_WIDTH, y_boundary)
    _line_to(x - HALF_TRIANGLE_WIDTH, y_boundary)
    _line_to(x, y)
    
    _stroke(color, 3)

    _move_to(x + TRIANGLE_MARGIN_LEFT, y)
    local y_boundary = y + TRIANGLE_WIDTH
    _line_to(x + HALF_TRIANGLE_WIDTH + TRIANGLE_MARGIN_LEFT, y_boundary)
    _line_to(x - HALF_TRIANGLE_WIDTH + TRIANGLE_MARGIN_LEFT, y_boundary)
    _line_to(x + TRIANGLE_MARGIN_LEFT, y)
    
    _stroke(color, 3)
end

canvas_id = canvas_add(0, 0, 883, 695, function()
  _rect(0, 0, 883, 695)
  _fill("#111111")
end)
local dig1_text = running_txt_add_ver(390, 135, 3, 50, 73, print_absolute_number,
  "size:84; color: white;")
local dig2_text = running_txt_add_ver(452, 135, 3, 50, 73, print_absolute_number,
  "size:84; color: white;")
local dig3_text = running_txt_add_ver(512, 135, 3, 50, 73, print_absolute_number,
  "size:84; color: white;")
local dig4_text = running_txt_add_ver(574, 135, 3, 50, 73, print_absolute_number,
  "size:84; color: white;")
local dig5_text = running_txt_add_ver(636, 135, 3, 50, 73, print_absolute_number,
  "size:84; color: white;")

img_add_fullscreen("background.png")
local img_knob = img_add("knob.png", 370, 350, 350, 350)

function arm()
    fs2020_variable_write("L:MCP_Alt_arm", "Number", 0.5);
    fs2020_variable_write("L:MCP_Alt_arm", "Number", 1);
end

local test_held = false;

function test_press()
    fs2020_variable_write("L:MCP_Alt_test_IsDown", "Number", 1);
end

function test_release()
    fs2020_variable_write("L:MCP_Alt_test_IsDown", "Number", 0);
end


button_add(nil, nil, 125, 180, 190, 140, arm, nil)
button_add(nil, nil, 203, 65, 40, 40, test_press, test_release)

il_canvas = canvas_add(0, 0, 883, 695);

local last_knob = 0;

local knob_variable = "L:MCP_Alt_sel_knob"

function on_knob_scroll(direction)
  if direction == -1 then
    last_knob = last_knob + 1;
    fs2020_variable_write(knob_variable, "Number", last_knob)
  end

  if direction == 1 then
    last_knob = last_knob - 1;
    fs2020_variable_write(knob_variable, "Number", last_knob)
  end
end

scrollwheel_add_ver(nil, 446, 431, 205, 205, 50, 50, on_knob_scroll)

function rotate_knob(knob)
  rotate(img_knob, knob * 10, "LINEAR", 0.5);
end

function update(dig1, dig2, dig3, dig4, dig5, knob, arm)

  local dig1_cap = var_cap(dig1, 0, 9);
  local dig2_cap = var_cap(dig2, 0, 9);
  local dig3_cap = var_cap(dig3, 0, 9);
  local dig4_cap = var_cap(dig3, 0, 9);
  local dig5_cap = var_cap(dig3, 0, 9);

  running_txt_move_carot(dig1_text, dig1_cap)
  running_txt_move_carot(dig2_text, dig2_cap)
  running_txt_move_carot(dig3_text, dig3_cap)
  running_txt_move_carot(dig3_text, dig3_cap)
  running_txt_move_carot(dig3_text, dig3_cap)
  canvas_draw(il_canvas, function() 

      if arm == 1 then
          illuminate_button()
      end
  end)

  rotate_knob(knob);
end

fs2020_variable_subscribe(
  "L:MCP_Alt_dig1", "Number",
  "L:MCP_Alt_dig2", "Number",
  "L:MCP_Alt_dig3", "Number",
  "L:MCP_Alt_dig4", "Number",
  "L:MCP_Alt_dig5", "Number",
  "L:MCP_Alt_sel_knob", "Number",
  "L:MCP_Alt_arm_il", "Number",
  update)

