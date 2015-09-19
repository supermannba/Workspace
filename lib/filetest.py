#!/usr/bin env python 3.4

# with open('New.txt','a') as infile:
# 	infile.write("write to test line1\n")
# 	infile.write("write to test line2\n")
# 	infile.write("write to test line3\n")
# infile.close()

f=open("New.txt",'r')
contents=f.readlines()
f.close()

contents.insert(3,"hahaha\n")

f=open("New.txt",'r')
contents="".join(contents)
f.write(contents)
f.close()
