trap = {}

bubble_sort_ins = open("./trap.txt", "r")

lines = bubble_sort_ins.readlines()

for line in lines:
    temp = line.split()
    if temp[0] == "core": 
        if temp[2][2] == "8":
            trap[temp[2]] = temp[3]

bubble_sort_ins.close()

for dict_key, dict_value in trap.items():  
    print(dict_key,'->',dict_value)