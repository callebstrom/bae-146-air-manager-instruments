--             BAe-146 TMS         --
-------------------------------------

function print_absolute_number(item_nr)
  if item_nr < 0 then
      return "" .. 10 + item_nr
  else
      return "" .. item_nr
  end
end

function print_plus_minus(item_nr)
  if item_nr == 0 then
      return "-"
  else
      return "+"
  end
end

canvas_id = canvas_add(0, 0, 690, 1080, function()
  _rect(387, 164, 37, 81)
  _rect(445, 164, 45, 81)
  _rect(505, 164, 37, 81)
  
  _rect(154,840, 39, 81)
  _rect(212,840, 45, 81)
  _rect(269,840, 39, 81)
  _fill("#333333")
end)

local tgt_dig1_text = txt_add("","font: inconsolata_bold.ttf; size:64px; color: white; halign:left;", 158,840,200,100)
local tgt_dig2_text = txt_add("","font: inconsolata_bold.ttf; size:64px; color: white; halign:left;", 214,840,200,100)
local tgt_dig3_text = txt_add("","font: inconsolata_bold.ttf; size:64px; color: white; halign:left;", 270,840,200,100)

local ref_dig1_text = running_txt_add_ver(390,170,2,50,52,print_plus_minus, "font: inconsolata_bold.ttf; size:64; color: white;")
local ref_dig2_text = running_txt_add_ver(455,170,10,50,52,print_absolute_number, "font: inconsolata_bold.ttf; size:64; color: white;")
local ref_dig3_text = running_txt_add_ver(510,170,10,50,52,print_absolute_number, "font: inconsolata_bold.ttf; size:64; color: white;")

img_add_fullscreen("background.png")

local ref_text = txt_add("","size:96px; color: orange; halign:left;", 80,142,200,100)
local ctrl_n1_text = txt_add("","font: inconsolata_bold.ttf; size:42px; color: white; halign:left;", 230,700,200,100)
local ctrl_n2_text = txt_add("","font: inconsolata_bold.ttf; size:42px; color: white; halign:left;", 270,700,200,100)
local mstr_1_text = txt_add("","font: inconsolata_bold.ttf; size:42px; color: white; halign:left;", 380,700,200,100)
local mstr_2_text = txt_add("","font: inconsolata_bold.ttf; size:42px; color: white; halign:left;", 420,700,200,100)
local pwr_on_text = txt_add("","font: inconsolata_bold.ttf; size:42px; color: white; halign:left;", 510,700,200,100)

local key_click_counter = {
    [1] = 0,
    [2] = 0,
    [3]= 0,
    [4] = 0,
    TO = 0,
    MCT = 0,
    TGT = 0,
    DESC = 0,
    SYNC = 0,
    CTRL = 0,
    MSTR = 0,
    PWR = 0,
    TEST = 0
}

function write(variable)
    return function(value) fs2020_variable_write(variable, "Number", value) end
end

local key_handler = {
    [1] = write("L:R_TMS_Eng1"),
    [2] = write("L:R_TMS_Eng2"),
    [3] = write("L:R_TMS_Eng3"),
    [4] = write("L:R_TMS_Eng4"),
    TO = write("L:R_TMS_To"),
    MCT = write("L:R_TMS_Mct"),
    TGT = write("L:R_TMS_Tgt"),
    DESC = write("L:R_TMS_Desc"),
    SYNC = write("L:R_TMS_Sync"),
    CTRL = write("L:R_TMS_Ctrl"),
    MSTR = write("L:R_TMS_Mstr"),
    PWR = write("L:R_TMS_Pwr"),
    TEST = write("L:R_TMS_Test"),
}

function on_press(key)
  key_click_counter[key] = key_click_counter[key] + 1;
  local value = key_click_counter[key];

  key_handler[key](value)
end

button_add(nil, nil, 54, 316, 143, 159, function() on_press(1) end, nil)
button_add(nil, nil, 195, 316, 143, 159, function() on_press(2) end, nil)
button_add(nil, nil, 349, 316, 143, 159, function() on_press(3) end, nil)
button_add(nil, nil, 489, 316, 143, 159, function() on_press(4) end, nil)

button_add(nil, nil, 54, 467, 143, 159, function() on_press("TO") end, nil)
button_add(nil, nil, 195, 467, 143, 159, function() on_press("MCT") end, nil)
button_add(nil, nil, 349, 467, 143, 159, function() on_press("TGT") end, nil)
button_add(nil, nil, 489, 467, 143, 159, function() on_press("DESC") end, nil)

button_add(nil, nil, 54, 618, 139, 149, function() on_press("SYNC") end, nil)
button_add(nil, nil, 195, 618, 139, 149, function() on_press("CTRL") end, nil)
button_add(nil, nil, 349, 618, 139, 149, function() on_press("MSTR") end, nil)
button_add(nil, nil, 489, 618, 139, 149, function() on_press("PWR") end, nil)

local TRIANGLE_WIDTH = 30;
local HALF_TRIANGLE_WIDTH =  TRIANGLE_WIDTH / 2
local FIRST_COL = 80;
local TRIANGLE_PADDING_LEFT = 20;
local TRIANGLE_LOCATION = FIRST_COL + TRIANGLE_PADDING_LEFT;
local COL_WIDTH = 142;
local ROW_INITIAL_OFFSET = 400;
local ROW_HEIGHT = 150
local COL_FACTOR = 5; -- Compensate for slightly uneven background :(

function draw_triangle(col, row, orientation, position, color)
    local left_margin = 0
    if position == "right" then
        left_margin = 40
    elseif position == "middle" then
        left_margin = 20
    end
    
    local top_margin = orientation == "down" and 30 or 0;
    
    local x = TRIANGLE_LOCATION + (col * COL_WIDTH) + (col * COL_FACTOR) + left_margin;
    local y = ROW_INITIAL_OFFSET + (ROW_HEIGHT * row) + top_margin;
    
    _move_to(x, y)
    local y_boundary = orientation == "down" and y - TRIANGLE_WIDTH or y + TRIANGLE_WIDTH
    _line_to(x + HALF_TRIANGLE_WIDTH, y_boundary)
    _line_to(x - HALF_TRIANGLE_WIDTH, y_boundary)
    
    if color ~= nil then 
       _fill(color)
    else
       _fill("cyan")
    end
end

function draw_square(col, row, orientation, position, color)
    local left_margin = 0
    if position == "right" then
        left_margin = 40
    elseif position == "middle" then
        left_margin = 20
    end
    
    local top_margin = orientation == "down" and 30 or 0;
    
    local x = TRIANGLE_LOCATION + (col * COL_WIDTH) + (col * COL_FACTOR) + left_margin;
    local y = ROW_INITIAL_OFFSET + (ROW_HEIGHT * row) + top_margin;
    
      _rect(x, y, 50, 50)
    

end

local TEST_SQUARE_SIZE = 55;
local TEST_SQUARE_LINES_WIDTH = 6;
    
canvas = canvas_add(0, 0, 690, 1080, nil)

local tms_test_green_button_overlay = img_add_fullscreen("tms_test_green_button_overlay.png")
visible(tms_test_green_button_overlay, false)

local tms_test_amber_button_overlay = img_add_fullscreen("tms_test_amber_button_overlay.png")
visible(tms_test_amber_button_overlay, false)

function draw_test_square(color)
    if color == nil then 
        _rect(563, 873, TEST_SQUARE_SIZE, TEST_SQUARE_SIZE)
        _fill("aquamarine")
        visible(tms_test_green_button_overlay, true)
    else
        visible(tms_test_amber_button_overlay, true)
        _rect(503, 873, TEST_SQUARE_SIZE, TEST_SQUARE_SIZE)
        _fill("yellow")
    end
end

function hide_test_square(color)
    if color == nil then 
        visible(tms_test_green_button_overlay, false)
    else
        visible(tms_test_amber_button_overlay, false)
    end
end

function update(eng1_n1,
                eng2_n1,
                eng1_n2,
                eng2_n2,
                ref_dig1,
                ref_dig2,
                ref_dig3,
                eng1_up,
                eng2_up,
                eng3_up,
                eng4_up,
                eng1_down,
                eng2_down,
                eng3_down,
                eng4_down,
                to1_up,
                to2_up,
                mct_up,
                tgt_up,
                desc_up,
                sync_up,
                ctrl_n1,
                ctrl_n2,
                mstr_1,
                mstr_2,
                pwr_on,
                tgt_dig1,
                tgt_dig2,
                tgt_dig3,
                test_green,
                test_amber,
                power)
    
    if power == true then
        power = 1
    else
        power = 0
    end
    
    local ref = 88.8;
    
    if ctrl_n1 == 1 then
        txt_set(ctrl_n1_text, "N1");
    elseif ctrl_n2 == 1 then
        txt_set(ctrl_n2_text, "N2");
    end
    
    if ctrl_n1 == 0 or to1_up == 1 then
        txt_set(ctrl_n1_text, "");
    elseif ctrl_n2 == 0 or to1_up == 1 then
        txt_set(ctrl_n2_text, "");
    end
    
    if desc_up == 1 then
        txt_set(ctrl_n1_text, "");
        txt_set(ctrl_n2_text, "");
    end
    
    if mstr_1 == 1 then
        txt_set(mstr_1_text, "1");
    end
    if mstr_2 == 1 then
        txt_set(mstr_2_text, "2");
    end
    
    if mstr_1 == 0 or to1_up == 1 then
        txt_set(mstr_1_text, "");
    end
    if mstr_2 == 0 or to1_up == 1 then
        txt_set(mstr_2_text, "");
    end
    
    local tgt_ref = tgt_dig1 * 100 + tgt_dig2 * 10 + tgt_dig3;
    
    if tgt_up == 1 then
        ref = tgt_ref;
    elseif ctrl_n1 == 1 and mstr_1 == 1 then
        ref = eng1_n1;
    elseif ctrl_n1 == 1 and mstr_2 == 1 then
        ref = eng2_n1;
    elseif ctrl_n2 == 1 and mstr_1 == 1 then
        ref = eng1_n2;
    elseif ctrl_n2 == 1 and mstr_2 == 1 then
        ref = eng2_n2;
    elseif desc_up == 1 then
        ref = 60.0;
    elseif mct_up == 1 then
        ref = 857
    end
    
    txt_set(ref_text, ref >= 100 and string.format("%.0f", ref) or string.format("%.1f", ref));
    
    txt_set(tgt_dig1_text, string.format("%.0f", var_cap(tgt_dig1, 0, 9)));
    txt_set(tgt_dig2_text, string.format("%.0f", var_cap(tgt_dig2, 0, 9)));
    txt_set(tgt_dig3_text, string.format("%.0f", var_cap(tgt_dig3, 0, 9)));
    
    local ref_dig2_cap = var_cap(ref_dig2, 0, 9);
    local ref_dig3_cap = var_cap(ref_dig3, 0, 9);

    running_txt_move_carot(ref_dig1_text, ref_dig1)
    running_txt_move_carot(ref_dig2_text, ref_dig2_cap - 5)
    running_txt_move_carot(ref_dig3_text, ref_dig3_cap - 5)
    
    if pwr_on == 1 then
        txt_set(pwr_on_text, "ON");
    else
        txt_set(pwr_on_text, "");
    end

    canvas_draw(canvas, function()
        if eng1_up == 1 then draw_triangle(0, 0, "up") end
        if eng2_up == 1 then draw_triangle(1, 0, "up") end
        if eng3_up == 1 then draw_triangle(2, 0, "up") end
        if eng4_up == 1 then draw_triangle(3, 0, "up") end
        
        if eng1_down == 1 then draw_triangle(0, 0, "down", "right", "white") end
        if eng2_down == 1 then draw_triangle(1, 0, "down", "right", "white") end
        if eng3_down == 1 then draw_triangle(2, 0, "down", "right", "white") end
        if eng4_down == 1 then draw_triangle(3, 0, "down", "right", "white") end
        
        if to1_up == 1 then draw_triangle(0, 1, "up", "left", "aquamarine") end
        if to2_up == 1 then draw_triangle(0, 1, "up", "right", "white") end
        if mct_up == 1 then draw_triangle(1, 1, "up", "middle", "aquamarine") end
        if tgt_up == 1 then draw_triangle(2, 1, "up", "middle", "aquamarine") end
        if desc_up == 1 then draw_triangle(3, 1, "up", "middle", "aquamarine") end
        
        if sync_up == 1 then draw_triangle(0, 2, "up", "middle", "aquamarine") end
        
        if test_green == 1 then draw_test_square() end
        if test_amber == 1 then draw_test_square("yellow") end
        if test_green == 0 then hide_test_square() end
        if test_amber == 0 then hide_test_square("yellow") end
    end)
end

fs2020_variable_subscribe("L:CTR_ENG1_N1_NEEDLE", "Number",
                          "L:CTR_ENG2_N1_NEEDLE", "Number",
                          "L:CTR_ENG1_N2_NEEDLE", "Number",
                          "L:CTR_ENG2_N2_NEEDLE", "Number",
                          "L:R_TMS_Ref_dig1", "Number",
                          "L:R_TMS_Ref_dig2", "Number",
                          "L:R_TMS_Ref_dig3", "Number",
                          "L:R_TMS_ENG1_UP_IL", "Number",
                          "L:R_TMS_ENG2_UP_IL", "Number",
                          "L:R_TMS_ENG3_UP_IL", "Number",
                          "L:R_TMS_ENG4_UP_IL", "Number",
                          "L:R_TMS_ENG1_DN_IL", "Number",
                          "L:R_TMS_ENG2_DN_IL", "Number",
                          "L:R_TMS_ENG3_DN_IL", "Number",
                          "L:R_TMS_ENG4_DN_IL", "Number",
                          "L:R_TMS_TO1_IL", "Number",
                          "L:R_TMS_TO2_IL", "Number",
                          "L:R_TMS_MCT_IL", "Number",
                          "L:R_TMS_TGT_IL", "Number",
                          "L:R_TMS_DESC_IL", "Number",
                          "L:R_TMS_SYNC_IL", "Number",
                          "L:R_TMS_CTRL_N1_IL", "Number",
                          "L:R_TMS_CTRL_N2_IL", "Number",
                          "L:R_TMS_MSTR_1_IL", "Number",
                          "L:R_TMS_MSTR_2_IL", "Number",
                          "L:R_TMS_PWR_ON_IL", "Number",
                          "L:R_TMS_TGT_DIG1", "Number",
                          "L:R_TMS_TGT_DIG2", "Number",
                          "L:R_TMS_TGT_DIG3", "Number",
                          "L:R_TMS_Test_green_il", "Number",
                          "L:R_TMS_Test_amber_il", "Number",
                          "ELECTRICAL MASTER BATTERY", "Bool",
                          update)                       