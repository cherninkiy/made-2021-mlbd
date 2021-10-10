#!/usr/bin/env python3
import sys

count = 0
summa = 0
squares = 0
for line in sys.stdin:
    _, x, x2 = line.split('\t')
    
    count += 1
    summa += float(x)
    squares += float(x2)

mean = summa/count
variance = squares/count - mean*mean
print(count, mean, variance, sep='\t')
