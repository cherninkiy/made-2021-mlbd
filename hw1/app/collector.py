#!/usr/bin/env python3
import sys

count = 0
mean = 0
variance = 0
for line in sys.stdin:
    ck, mk, vk = line.split('\t')

    ck, mk, vk = int(ck), float(mk), float(vk)
    
    cj, mj, vj = count, mean, variance

    count = cj + ck
    mean = (cj * mj + ck * mk) / count

    wj = (mj - mk) / count
    variance = (cj * vj + ck * vk) / count + cj * ck * wj * wj

print(count, mean, variance, sep='\t')
