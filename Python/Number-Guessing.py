import random

def askmax():
    try:
        maxnum = abs(int(input("What is the highest number you want? : ")))
        return(maxnum)
    except:
        print("Please enter a valid number.")
        return(askmax())

def ask(value):
    try:
        ans = int(input("Guess the number between 1-"+str(value)+": "))
        return(ans)
    except:
        print("Please enter a valid number.")
        return(ask(value))

def check(innum, num, maxnum):
    if innum == num:
        print("Correct")
        print("-----------------------------------------------")
        return("break")
    elif innum > maxnum or innum < 1:
        print("The number is between 1-"+str(maxnum))
        print()
    elif innum > num:
        print("Lower")
        print()
    elif innum < num:
        print("Higher")
        print()

while True:
    maxnum = int(askmax())
    if maxnum:
        break

num = random.randint(1, maxnum)

while True:
    if check(ask(maxnum), num, maxnum) == "break":
        break
