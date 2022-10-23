--         BAe-146 TGT Gauge        --
-------------------------------------

local MIN_BUG_ROTATION = 65;
local MAX_BUG_ROTATION = 345;
local BUG_RANGE = MAX_BUG_ROTATION - MIN_BUG_ROTATION;

local MIN_NEEDLE_ROTATION = 7;
local MAX_NEEDLE_ROTATION = 285;
local NEEDLE_RANGE = MAX_NEEDLE_ROTATION - MIN_NEEDLE_ROTATION;

img_add_fullscreen("background.png")
img_n1_bug = img_add_fullscreen("gauge_bug.png")
img_n1_bug_knob = img_add_fullscreen("gauge_bug_knob.png")
img_n1_needle = img_add_fullscreen("gauge_needle.png")

rotate(img_n1_bug, MAX_BUG_ROTATION);
move(img_n1_bug_knob, 87, 87);

local engine_user_prop = user_prop_add_enum("Engine", "ENG1,ENG2,ENG3,ENG4", "ENG1", "Engine");
local engine_n1_value_dig1_text = txt_add(" ","size:48px; color: white; halign:left;", 90,163,150,100)
local engine_n1_value_dig2_text = txt_add(" ","size:48px; color: white; halign:left;", 115,163,150,100)
local engine_n1_value_dig3_text = txt_add(" ","size:48px; color: white; halign:left;", 145,163,150,100)
local engine_n1_bug_dig1_text = txt_add(" ","size:22px; color: yellow; halign:left;", 112,72,150,100)
local engine_n1_bug_dig2_text = txt_add(" ","size:22px; color: yellow; halign:left;", 124,72,150,100)
local engine_n1_bug_dig3_text = txt_add(" ","size:22px; color: yellow; halign:left;", 136,72,150,100)

local last_n1_bug_knob = 0;

local bug_knob_variable = "L:CTR_" .. user_prop_get(engine_user_prop) .. "_TGT_BUG_KNOB"

function on_knob_scroll(direction)
  if direction == -1 then
    last_n1_bug_knob = last_n1_bug_knob + 1;
    fs2020_variable_write(bug_knob_variable, "Number", last_n1_bug_knob)
  end

  if direction == 1 then
    last_n1_bug_knob = last_n1_bug_knob - 1;
    fs2020_variable_write(bug_knob_variable, "Number", last_n1_bug_knob)
  end
end

scrollwheel_add_ver(nil, 192, 192, 60, 60, 50, 50, on_knob_scroll)

function rotate_bug(n1_bug_needle)
    local percentage_rotated = n1_bug_needle / 120;
    local actual_rotation = MIN_BUG_ROTATION + (BUG_RANGE * percentage_rotated);
    
    rotate(img_n1_bug, actual_rotation);
end

function rotate_needle(n1_needle)
    local percentage_rotated = n1_needle / 120;
    local actual_rotation = MIN_NEEDLE_ROTATION + (NEEDLE_RANGE * percentage_rotated);
    
    rotate(img_n1_needle, actual_rotation);
end

function rotate_bug_knob(n1_bug_knob)
    rotate(img_n1_bug_knob, n1_bug_knob * 10);
end

function update(n1_dig1, n1_dig2, n1_dig3, n1_needle, n1_bug_dig1, n1_bug_dig2, n1_bug_dig3, n1_bug_needle, n1_bug_knob, power)

    local n1_dig1_cap = var_cap(n1_dig1, 0, 9);
    local n1_dig2_cap = var_cap(n1_dig2, 0, 9);
    local n1_dig3_cap = var_cap(n1_dig3, 0, 9);
    
    local n1_bug_dig1_cap = var_cap(n1_bug_dig1, 0, 9);
    local n1_bug_dig2_cap = var_cap(n1_bug_dig2, 0, 9);
    local n1_bug_dig3_cap = var_cap(n1_bug_dig3, 0, 9);
    
    if power == true then
        power = 1
    else
        power = 0
    end
    
    if power >= 1 then
        txt_set(engine_n1_value_dig1_text, string.format("%.0f", n1_dig1_cap))
        txt_set(engine_n1_value_dig2_text, string.format("%.0f", n1_dig2_cap))
        txt_set(engine_n1_value_dig3_text, string.format("%.f", n1_dig3_cap))
        txt_set(engine_n1_bug_dig1_text, string.format("%.0f", n1_bug_dig1_cap))
        txt_set(engine_n1_bug_dig2_text, string.format("%.0f", n1_bug_dig2_cap))
        txt_set(engine_n1_bug_dig3_text, string.format("%.0f", n1_bug_dig3_cap))
    else
        txt_set(engine_n1_value_text, "000")
        txt_set(engine_n1_bug_text, "000")
    end
    
    rotate_bug(n1_bug_needle);
    rotate_needle(n1_needle);
    rotate_bug_knob(n1_bug_knob);
end

fs2020_variable_subscribe("L:CTR_" .. user_prop_get(engine_user_prop) .. "_TGT_TEMP_DIG1", "Number",
                          "L:CTR_" .. user_prop_get(engine_user_prop) .. "_TGT_TEMP_DIG2", "Number",
                          "L:CTR_" .. user_prop_get(engine_user_prop) .. "_TGT_TEMP_DIG3", "Number",
                          "L:CTR_" .. user_prop_get(engine_user_prop) .. "_TGT_NEEDLE", "Number",
                          "L:CTR_" .. user_prop_get(engine_user_prop) .. "_TGT_BUG_DIG1", "Number",
                          "L:CTR_" .. user_prop_get(engine_user_prop) .. "_TGT_BUG_DIG2", "Number",
                          "L:CTR_" .. user_prop_get(engine_user_prop) .. "_TGT_BUG_DIG3", "Number",
                          "L:CTR_" .. user_prop_get(engine_user_prop) .. "_TGT_BUG", "Number",
                          bug_knob_variable, "Number",
                          "ELECTRICAL MASTER BATTERY", "Bool",
                          update)                       