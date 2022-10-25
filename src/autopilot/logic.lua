--         BAe-146 Autopilot       --
-------------------------------------

local TRIANGLE_WIDTH = 30;
local HALF_TRIANGLE_WIDTH =  TRIANGLE_WIDTH / 2
local FIRST_COL = 137;
local TRIANGLE_MARGIN_LEFT = 55;
local TRIANGLE_LOCATION = FIRST_COL + TRIANGLE_MARGIN_LEFT;
local COL_WIDTH = 148;
local ROW_INITIAL_OFFSET = 270;
local ROW_HEIGHT = 200
local COL_FACTOR = 5; -- Compensate for slightly uneven background :(

img_add_fullscreen("background.png")

canvas = canvas_add(0, 0, 1200, 635, function()

end)

function illuminate_button(col, row, color)
    color = color == nil and "yellow" or color
    local x = TRIANGLE_LOCATION + (col * COL_WIDTH) + (col * COL_FACTOR);
    local y = ROW_INITIAL_OFFSET + (ROW_HEIGHT * row);
    
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

local turb_1 = txt_add("1","font: inconsolata_bold.ttf; size:42px; color: yellow; halign:left;", 558, 513, 200, 100)
local turb_2 = txt_add("2","font: inconsolata_bold.ttf; size:42px; color: yellow; halign:left;", 622, 513, 200, 100)

function illuminate_turb()
    illuminate_button(2.5, 0.96)
    visible(turb_1, true)
    visible(turb_2, true)
end

function dim_turb()
    visible(turb_1, false)
    visible(turb_2, false)
end

dim_turb()

function update(ap_mode, gsl_mode, alt_mode, vs_mode, mach_mode, vnav_mode, ias_mode, vl_mode, bloc_mode, lnav_mode, hdg_mode, turb_mode)
    canvas_draw(canvas, function()
        if (ap_mode == 1) then
            illuminate_button(2.5, -0.85, "green")
        end
    
        if (gsl_mode == 1) then
            illuminate_button(0, 0)
        end
        
        if (alt_mode == 1) then
            illuminate_button(1, 0)
        end
        
        if (vs_mode == 1) then
            illuminate_button(2, 0)
        end
        
        if (mach_mode == 1) then
            illuminate_button(3, 0)
        end
        
        if (vnav_mode == 1) then
            illuminate_button(4, 0)
        end
        
        if (ias_mode == 1) then
            illuminate_button(5, 0)
        end
        
        if (vl_mode == 1) then
            illuminate_button(0, 1)
        end
        
        if (bloc_mode == 1) then
            illuminate_button(1, 1)
        end

        if (lnav_mode == 1) then
            illuminate_button(4, 1)
        end
        
        if (hdg_mode == 1) then
            illuminate_button(5, 1)
        end
        
        if (turb_mode == 1) then
            illuminate_turb()
        end
        
        if (turb_mode == 0) then
            dim_turb()
        end
    end)
end

fs2020_variable_subscribe("L:MCP_Mode_AP_il", "Number",
                          "L:MCP_Mode_GSL_il", "Number",
                          "L:MCP_Mode_ALT_il", "Number",
                          "L:MCP_Mode_VS_il", "Number",
                          "L:MCP_Mode_MACH_il", "Number",
                          "L:MCP_Mode_VNAV_il", "Number",
                          "L:MCP_Mode_IAS_il", "Number",
                          "L:MCP_Mode_VL_il", "Number",
                          "L:MCP_Mode_BLOC_il", "Number",
                          "L:MCP_Mode_LNAV_il", "Number",
                          "L:MCP_Mode_HDG_il", "Number",
                          "L:MCP_Mode_TURB_il", "Number",
                          update)                       