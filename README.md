# RISCVCPU

代码位于 RISCVCPU\RISCV\RISCV.srcs\sources_1\new下

## 使用方法

1. 使用vivado打开RISCV项目文件
2. 点击TOP->if_unit:IF->instMem
3. 选择加载Fibonacci.coe文件（位于test_program四个文件夹下）加载后
4. 修改ram中mem初始化文件位置（位于test_program四个文件夹下）
5. 点击运行仿真
6. 若仿真正确，寄存器和RAM值如文档中所示