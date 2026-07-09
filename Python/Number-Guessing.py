#Import function
import random

#Functions
def ask_max_number():
    while True:
        try:
            maxnum = abs(int(input("What is the highest number you want? : ")))
            return(maxnum)
            break
        except:
            print(f"Please enter a valid number.\n")

def ask(value):
    while True:
        try:
            ans = int(input(f"Guess the number between 1-{str(value)}: "))
            return(ans)
            break
        except:
            print(f"Please enter a valid number.\n")

def check(innum, num, maxnum):
    if innum == num:
        print("Correct")
        return(True)
    elif innum > maxnum or innum < 1:
        print("The number is between 1-"+str(maxnum))
    elif innum > num:
        print("Lower")
    elif innum < num:
        print("Higher")

#Code
maxnum = ask_max_number()
num = random.randint(1, maxnum)

while True:
    if check(ask(maxnum), num, maxnum):
        break
