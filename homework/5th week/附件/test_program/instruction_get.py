instruction = []
instruction16 = []

bubble_sort_ins = open("./BubbleSort.txt", "r")

lines = bubble_sort_ins.readlines()

for line in lines:
    temp = line.split()
    if len(temp) >= 3 and temp[0][len(temp[0]) - 1] == ":" and temp[2] != "format":
        instruction.append(temp[2])
        if len(temp[1]) == 4:
            instruction16.append(temp[2])

bubble_sort_ins.close()

bubble_sort_ins = open("./BubbleSort_ass.txt", "r")

lines = bubble_sort_ins.readlines()

for line in lines:
    temp = line.split()
    if len(temp) >= 3 and temp[0][len(temp[0]) - 1] == ":" and temp[2] != "format":
        instruction.append(temp[2])
        if len(temp[1]) == 4:
            instruction16.append(temp[2])

bubble_sort_ins.close()

fibonacci_ins = open("./Fibonacci.txt", "r")

lines = fibonacci_ins.readlines()

for line in lines:
    temp = line.split()
    if len(temp) >= 3 and temp[0][len(temp[0]) - 1] == ":" and temp[2] != "format":
        instruction.append(temp[2])
        if len(temp[1]) == 4:
            instruction16.append(temp[2])

fibonacci_ins.close()

fibonacci_ins = open("./Fibonacci_ass.txt", "r")

lines = fibonacci_ins.readlines()

for line in lines:
    temp = line.split()
    if len(temp) >= 3 and temp[0][len(temp[0]) - 1] == ":" and temp[2] != "format":
        instruction.append(temp[2])
        if len(temp[1]) == 4:
            instruction16.append(temp[2])

fibonacci_ins.close()

print(len(set(instruction)))

print(set(instruction))

print(set(instruction16))

result = set(instruction)

w = open('instruction.txt', 'w')

w.write(','.join(result))
