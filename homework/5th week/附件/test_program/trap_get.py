# trap = {}

# bubble_sort_ins = open("./trap.txt", "r")

# lines = bubble_sort_ins.readlines()

# for line in lines:
#     temp = line.split()
#     if temp[0] == "core": 
#         if temp[2][2] == "8":
#             trap[temp[2]] = line

# bubble_sort_ins.close()

# keys = sorted(trap.keys())

# for key in keys:
#     print(trap[key])

# for dict_key, dict_value in trap.items():  
#     print(dict_value)

trap = []

bubble_sort_ins = open("./trap_program.txt", "r")

lines = bubble_sort_ins.readlines()

for line in lines:
    temp = line.split()
    trap.append(temp[1])

bubble_sort_ins.close()

for t in trap:
    print(t)