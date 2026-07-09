#Import function
import random

#Variables
dictionary = {"r":"🪨","p":"📄","s":"✂️"}
choices = ("r","p","s")

#Functions
def ask_choices():
    ans = input(f"\nRock, Paper or Scissor? (r, p, s): ")
    if ans in choices:
        return(ans)
    else:
        print("Sorry please try again.")
        print()
        return(ask_choices())

def check(ans,bot_choice):
    print("You choose " +dictionary[ans]+".")
    print("The bot_choice choose " +dictionary[bot_choice]+".")
    print()
    if ans == bot_choice:
        print("It's a tie!")
    elif ans == "r" and bot_choice == "p" or \
    ans == "p" and bot_choice == "s" or \
    ans == "s" and bot_choice == "r":
       print("The bot win!")
    elif ans == "r" and bot_choice == "s" or \
    ans == "p" and bot_choice == "r" or \
    ans == "s" and bot_choice == "p":
        print("You win!")

def ask_playagain():
    while True:
        playagain = str(input("Do you want to play again? (Y, N): "))
        if playagain == "n" or playagain == "N":
            return(False)
            break
        elif playagain == "y" or playagain == "Y":
            return(True)
            break
        else:
            print("Sorry please try again.")

#code
while True:
    bot_choice = random.choice(choices)
    ans = ask_choices()
    check(ans,bot_choice)
    if not ask_playagain():
        break
