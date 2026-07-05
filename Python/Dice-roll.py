import random

def askyorn():
    ans = str(input("Roll the dice? (Y, N): "))
    if ans == "y" or ans == "n" or ans=="Y"or ans =="N":
        roll = ans == "y" or ans == "Y"
        return(roll)
    else:
        print("Sorry please try again.")
        print()
        return(askyorn())

def askamount():
    ans = input("How much dice do you want to roll? (1-3): ")
    if ans == "1" or ans == "2" or ans == "3":
        return(int(ans))
    else:
        print("Sorry please try again.")
        return(askamount())

def gambling(amount):
    fnum = random.randint(1,6)
    snum = random.randint(1,6)
    tnum = random.randint(1,6)
    if amount == 1:
        return(fnum)
    elif amount == 2:
        return(fnum,snum)
    elif amount == 3:
        return(fnum,snum,tnum)
        
if askyorn():
    print()
    print(gambling(askamount()))
