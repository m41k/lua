#!/bin/lua
--############################--
--# Created by Maik Alberto  #--
--# maik.alberto@hotmail.com #--
--############################--
-- Converted to Lua 5.1/Fltk - MurgaLua - by RS 12/13/06
-- Added code to test number of mouse buttons - RS 12/15/06
-- Write to .mouse_config for persistence     - RS 02/15/07
require("fltk")
dofile("/etc/init.d/functions5.lua")

-- DSL - Mouse --

results,err=capturing("xmodmap -pp|head -1|cut -f3 -d' '")
mousetype = results[1]

--Janela--
w = fltk:Fl_Window(300,200, "DSL - Mouse Config")
--#

--Titulo--
titulo = fltk:Fl_Box(50,5,200,30,"DSL - Mouse Config")
titulo:labelsize(15)
titulo:labelfont(fltk.FL_HELVETICA_BOLD)
titulo:labeltype(fltk.FL_EMBOSSED_LABEL)
--#

--Variavel Inicial--
xyz = "xset m 6/1 0"
--#

--Barra de Velocidade--

vel = fltk:Fl_Value_Slider(50,60,205,20,"Speed")
vel:align(fltk.FL_ALIGN_TOP+fltk.FL_ALIGN_CENTER)
vel:labelfont(fltk.FL_HELVETICA_BOLD_ITALIC)
vel:type(1)
vel:color(fltk.FL_WHITE)
vel:selection_color(fltk.FL_RED)
vel:textcolor(fltk.FL_BLACK)
vel:textfont(fltk.FL_HELVETICA_BOLD)
vel:minimum(1)
vel:maximum(10)
vel:step(1)
vel:value(6)
vel:callback(
  function(vel)
  x = vel:value()
  y = "/1"
  z = " 0"
  xyz = ("xset m " .. x .. y.. z)
  end
)
--#

--Botão Seleçãoo--
destro_bnt = fltk:Fl_Round_Button(120,95,30,25, "Right Button")
destro_bnt:type(fltk.FL_RADIO_BUTTON)
destro_bnt:value(1)
destro_bnt:callback(set_vel)

canhoto_bnt = fltk:Fl_Round_Button(120,120,30,25, "Left Button") --#
canhoto_bnt:type(fltk.FL_RADIO_BUTTON)
canhoto_bnt:callback(set_vel)

--Botões de Aplicação--
botao1 = fltk:Fl_Button(50,160,80,25, "&Apply")
botao1:shortcut('a')
botao1:callback(
  function(botao1)
    if destro_bnt:value() == 1 then
      if mousetype == "3" then
         pointer_order = "1 2 3"
      else
         pointer_order = "1 2 3 4 5"
      end
    else
      if mousetype == "3" then
         pointer_order = "3 2 1"
      else
         pointer_order = "3 2 1 4 5"
      end
    end
    io.output(".mouse_config")
    io.write(xyz.."\n")
    io.write ("xmodmap -e \'pointer = "..pointer_order.."\'\n")
    io.flush()
    os.execute (xyz)
    os.execute ("xmodmap -e \'pointer = "..pointer_order.."\'")
  end
)

botao2 = fltk:Fl_Button(175,160,80,25, "&Exit")
botao2:shortcut('e')
botao2:callback(
  function(botao2)
    os.exit()
  end
)
--#

w:show()
Fl:run()
