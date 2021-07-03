指令集的选择

1.RV32I：包含Shift移位、Arithmetic算术运算、Logical逻辑运算、Compare比较、Branch分支、Jump&Link跳转、Synch同步、Environment环境相关、Load取、Store存、CSR控制状态寄存器相关的几大类指令，共47条；

扩展的10条指令选择RVM和自定义的两条指令。
2.RVM：选择RV扩展的RVM指令集，包含乘除取余三类运算，共8条指令。
3.自定义指令：自定义指令考虑到了常用的循环变量在循环中自加的循环格式，在BNE和BNQ指令的基础上，对rs1增加自加1的功能，共2条指令。