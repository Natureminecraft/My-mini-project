#Import function
import random

#Functions
def ask_yes_or_no():
    while True:
        yes = ("y","Y")
        no = ("n", "N")
        ans = str(input("Roll the dice? (Y, N): "))
        if ans in yes or ans in no:
            return(ans in yes)
        else:
            print(f"Sorry please try again.\n")

def ask_amount():
    while True:
        try:
            ans = int(input("How much dice do you want to roll? : "))
            return(ans)
            break
        except:
            print(f"Please enter a valid number.\n")

def random_number(amount):
    num = str(random.randint(1,6))
    for i in range(amount-1):
        num = num + " " + str(random.randint(1,6))
    return(num)

#Code
while ask_yes_or_no():
    print(f"\n{random_number(ask_amount())}")

# :)
