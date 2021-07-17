instruction = []

for i in range(0,16413):
    instruction.append("00000000")

fibonacci_ins = open("./Fibonacci.txt", "r")

lines = fibonacci_ins.readlines()

for line in lines:
    temp = line.split()
    if len(temp) >= 3 and temp[0][len(temp[0]) - 1] == ":" and temp[2] != "format":
        instruction.append(temp[1])

fibonacci_ins.close()

w = open('instruction.txt', 'w')

w.write('\n'.join(instruction))
