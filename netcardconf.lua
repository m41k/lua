#!/bin/lua

--############################--
--# Created by Maik Alberto  #--
--# maik.alberto@hotmail.com #--
--############################--
--[[
Mods by RS 10/05/07
 Changed logic of removing duplicates from /opt/bootlocal.sh 
 Added logic to add to .filetool.lst
 Added defaults for netmask and nameserver.
 Added function to calculate broadcast.
]]--

require("fltk")
home = os.getenv("HOME")
io.input("/etc/hostname")
hostname = io.read("*line")
io.input()

function calc_broadcast()
  if inputip:value() ~= "" then
    ipcalc = io.popen("ipcalc -b "..inputip:value().." "..inputmask:value().."|cut -f2 -d=")
    for line in ipcalc:lines() do
      result = line
    end
    inputbroad:value(result)
  else
    inputbroad:value("")
  end

  local data = ""
  for hit,nohit in string.gmatch(inputip:value(),"(%d+%.)") do
     if hit ~= "" then
        data = data..hit
     end
  end
  inputgw:value(data.."254")
end

ns = {}
nsdata = io.popen(" grep '^nameserver' /etc/resolv.conf|cut -f2 -d' '")
for i in nsdata:lines() do
  ns[#ns + 1] = i
end

w = fltk:Fl_Window(250, 450, "DSL - Netcard Config");

titulo = fltk:Fl_Box(0, 0, 250, 25, "DSL - Netcard Config");
titulo:box(fltk.FL_ENGRAVED_BOX);
titulo:labelfont(1);
titulo:labelsize(16);

tinterface = fltk:Fl_Box(0, 31, 250, 20, "Interface");
tinterface:labelfont(1);
tinterface:labelsize(12);

inputint = fltk:Fl_Input(50, 50, 150, 20);
inputint:value("eth0");
inputint:box(fltk.FL_BORDER_BOX);
inputint:labelsize(12);
inputint:textsize(12);

tdhcp = fltk:Fl_Box(0, 74, 250, 20, "Use DHCP Broadcast?");
tdhcp:labelfont(1);
tdhcp:labelsize(12);

opd1 = fltk:Fl_Round_Button(80, 93, 45, 25, "yes");
-- opd1:type(fltk.FL_RADIO_BUTTON);
opd1:callback(
  function(opd1)
    opd1:value(1)
    opd2:value(0)
    inputip:deactivate()
    inputmask:deactivate()
    inputbroad:deactivate()
    inputgw:deactivate()
    inputns1:deactivate()
    inputns2:deactivate()
  end
)

opd2 = fltk:Fl_Round_Button(125, 93, 45, 25, "no");
opd2:value(1);
opd2:callback(
  function(opd2)
    opd1:value(0)
    opd2:value(2)
    inputip:activate()
    inputmask:activate()
    inputbroad:activate()
    inputgw:activate()
    inputns1:activate()
    inputns2:activate()
  end
)

tip = fltk:Fl_Box(0, 117, 250, 19, "Address IP");
tip:labelfont(1);
tip:labelsize(12);

inputip = fltk:Fl_Input(50, 135, 150, 20);
inputip:box(fltk.FL_BORDER_BOX);
inputip:labelsize(12);
inputip:textsize(12);
inputip:when(fltk.FL_LEAVE)
inputip:callback(calc_broadcast)

tmask = fltk:Fl_Box(0, 159, 250, 19, "Network Mask");
tmask:labelfont(1);
tmask:labelsize(12);

inputmask = fltk:Fl_Input(50, 177, 150, 20);
inputmask:box(fltk.FL_BORDER_BOX);
inputmask:labelsize(12);
inputmask:textsize(12);
inputmask:value("255.255.255.0")
inputmask:when(fltk.FL_LEAVE)
inputmask:callback(calc_broadcast)

tbroadcast = fltk:Fl_Box(0, 201, 250, 19, "Broadcast");
tbroadcast:labelfont(1);
tbroadcast:labelsize(12);

inputbroad = fltk:Fl_Input(50, 219, 150, 20);
inputbroad:box(fltk.FL_BORDER_BOX);
inputbroad:labelsize(12);
inputbroad:textsize(12);

tgw = fltk:Fl_Box(0, 243, 250, 19, "Gateway");
tgw:labelfont(1);
tgw:labelsize(12);

inputgw = fltk:Fl_Input(50, 261, 150, 20);
inputgw:box(fltk.FL_BORDER_BOX);
inputgw:labelsize(12);
inputgw:textsize(12);

tns = fltk:Fl_Box(0, 285, 250, 19, "Nameserver(s)");
tns:labelfont(1);
tns:labelsize(12);

inputns1 = fltk:Fl_Input(50, 308, 150, 20);
inputns1:box(fltk.FL_BORDER_BOX);
inputns1:labelsize(12);
inputns1:textsize(12);
inputns1:value(ns[1])

inputns2 = fltk:Fl_Input(50, 332, 150, 20);
inputns2:box(fltk.FL_BORDER_BOX);
inputns2:labelsize(12);
inputns2:textsize(12);
inputns2:value(ns[2])

tsave = fltk:Fl_Box(0, 356, 250, 19, "Save configuration");
tsave:labelfont(1);
tsave:labelsize(12);

sv1 = fltk:Fl_Round_Button(80, 380, 45, 25, "yes");
sv1:type(fltk.FL_RADIO_BUTTON);
sv1:value(1);
sv2 = fltk:Fl_Round_Button(125, 380, 45, 25, "no");
sv2:type(fltk.FL_RADIO_BUTTON);

tsave2 = fltk:Fl_Box(0, 368, 250, 19, "in the system?");
tsave2:labelfont(1);
tsave2:labelsize(12);

botao1 = fltk:Fl_Button(40, 415, 75, 25, "&Apply");
botao1:callback(
function(botao1)

--var--
varint = inputint:value();
varip = inputip:value();
varmsk = inputmask:value();
varbrd = inputbroad:value();
vargw = inputgw:value();
varns1 = inputns1:value();
varns2 = inputns2:value();
--

--se--

--Trabalhar no pump --> /dev/null 2>&1

if opd1:value() == 1 then
  os.execute("sudo pump -h "..hostname.." -i " ..varint .." &")
else
  os.execute("sudo pump -h "..hostname.." -k -i " ..varint .." >/dev/null")
  os.execute("sudo ifconfig " ..varint .." " ..varip .." netmask " ..varmsk .." broadcast " .. varbrd .." up")
  os.execute("sudo route add default gw " ..vargw)
  os.execute("echo nameserver " ..varns1 .." |sudo tee /etc/resolv.conf")
  if varns2 ~= "" then
    os.execute("echo nameserver " ..varns2 .. " |sudo tee -a /etc/resolv.conf")
  end
end

if sv1:value() == 1 then
  os.execute("echo '#'!/bin/bash > /opt/" ..varint ..".sh")
  os.execute("echo pkill pump >> /opt/" ..varint ..".sh")
  if opd1:value() == 1 then
    os.execute("echo pump -h "..hostname.." -i " ..varint .." >> /opt/" ..varint ..".sh")
  else
    os.execute("echo ifconfig " ..varint .." " ..varip .." netmask " ..varmsk .." broadcast " .. varbrd .." up >> /opt/" ..varint ..".sh")
    os.execute("echo route add default gw " ..vargw .." >> /opt/" ..varint ..".sh")
    os.execute("echo nameserver " ..varns1 .." |sudo tee /etc/resolv.conf")
    if varns2 ~= "" then
      os.execute("echo nameserver " ..varns2 .. " |sudo tee -a /etc/resolv.conf")
    end
  end
  os.execute("sudo chmod +x /opt/" ..varint ..".sh")
  os.execute("sed -i '/"..varint..".sh/d' /opt/bootlocal.sh") 
  os.execute("echo /opt/" ..varint ..".sh '&'" .."|sudo tee -a /opt/bootlocal.sh")
  os.execute("sed -i '/"..varint..".sh/d' /opt/.filetool.lst") 
  os.execute("echo opt/" ..varint ..".sh ".. "|tee -a /opt/.filetool.lst")
end

end
)

botao2 = fltk:Fl_Button(135, 415, 75, 25, "&Exit");
botao2:shortcut('e')
botao2:callback(
function(botao2)
os.exit()
end
)

w:show();
Fl:run();
