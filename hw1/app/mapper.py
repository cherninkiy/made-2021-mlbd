#!/usr/bin/env python3
import sys
import csv

NUM_REDUCERS=3

reader = csv.reader(sys.stdin)
for i, row in enumerate(reader):
    x = float(row[9])
    print(i % NUM_REDUCERS, x, x*x, sep='\t')

