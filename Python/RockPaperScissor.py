import random

dictionary = {"r":"rock","p":"paper","s":"scissor"}
choices = ("r","p","s")
bot = random.choice(choices)

def ask_choices():
    ans = input("Rock, Paper or Scissor? (r, p, s): ")
    if ans in choices:
        return(ans)
    else:
        print("Sorry please try again.")
        print()
        return(ask_choices())

def check(ans,bot):
    print("You choose " +dictionary[ans]+".")
    print("The bot choose " +dictionary[bot]+".")
    print()
    if ans == bot:
        print("It's a tie!")
    elif ans == "r" and bot == "p":
        print("The bot win!")
    elif ans == "r" and bot == "s":
        print("You win!")
    elif ans == "p" and bot == "r":
        print("You win!")
    elif ans == "p" and bot == "s":
        print("The bot win!")
    elif ans == "s" and bot == "r":
        print("The bot win!")
    elif ans == "s" and bot == "p":
        print("You win!")

while True:
    ans = ask_choices()
    check(ans,bot)
    print()
    playagain = str(input("Do you want to play again? (Y, N): "))
    if playagain == "n" or playagain == "N":
        break
    elif playagain == "y" or playagain == "Y":
        print()
    else:
        print("Sorry please try again.")
        print()
