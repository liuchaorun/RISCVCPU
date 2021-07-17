onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib prgROM_opt

do {wave.do}

view wave
view structure
view signals

do {prgROM.udo}

run -all

quit -force
