import numpy


path_to_data = "benan.npy"
data = numpy.load(path_to_data)

mean = numpy.mean(data)
variance = numpy.var(data)
std_deviation = numpy.std(data)

print(len(data))
print(mean)
print(variance)
print(std_deviation)
print(data)