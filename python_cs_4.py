# -*- coding: utf-8 -*-
"""python cs - 4.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1bDldtf1cM53HtAkE6swD9CVaXeifgj8B
"""

#1.  Grades Assignment : Write a program that assigns grades to students based on their scores.
def grades_assign(score):
  if score>=90:
    print("your grade is : A")
  elif score<90 and score>=80:
    print("your grade is : B")
  elif score<80 and score >=60:
    print("your grade is : c")
  elif score<60 and score>=40:
    print("your grade is : D")
  else:
    print("fail")

score=int(input("enter your score: "))
grades_assign(score)

#2.  Age Verification : Write a program that checks if a person is eligible to vote.

age=int(input("enter your age: "))
if age<=18:
    print("Not eligible to vote")
else:
    print("eligible to vote")

#3.  Discount Calculation : Write a program that calculates the final price after applying a discount.

def products(items,discount):
     disc=items-(items*discount/100)
     print(f"your discount is price {disc}")


items_price=int(input("select your items price(TV,Ipad,Laptop): "))
discount=int(input("enter your discount"))
products(items_price,discount)

#4.  Temperature Conversion : Write a program that converts temperature from Celsius to Fahrenheit.
celsius=47
fahrenheit=(celsius * 9/5) + 32
print(f"fahrenheit : {fahrenheit}")

#5.  Even or Odd : Write a program that checks if a number is even or odd.
num=int(input("enter a number: "))
if num%2==0:
    print(f"The number is even :{num}")
else:
    print(f"The number is odd :{num}")

#6.  Positive or Negative : Write a program that checks if a number is positive, negative, or zero.
num=int(input("enter a number: "))
if num>=1:
  print(f"the number is positive: {num}")
elif num<=-1:
  print(f"the number is negtive: {num}")
else:
  print(f"the number is zero:{num}")

#7.  Student Admission : Write a program that checks if a student is admitted based on their test score.
def grades_assign(score):
  if score<=100 and score>=40:
    print("the student is admitted based on the score")

  else:
    print("the student is not admitted based on the score")

score=int(input("enter your score: "))
grades_assign(score)

#8.  Discount Eligibility : Write a program that checks if a customer is eligible for a discount based on their purchase amount.

def products(items):
  if items>=10000:
     discount=int(input("enter your discount: "))
     disc=items-(items*discount/100)
     print(f"your discount is price {disc}")
  else:
    print("you are not eligible for discount")


items_price=int(input("select your items price(TV,Ipad,Laptop): "))

products(items_price)

#9.  Prime Number Check : Write a program that checks if a number is prime.
num = 11
if num > 1:
    for i in range(2, (num//2)+1):
        if (num % i) == 0:
            print(num, "is not a prime number")
            break
    else:
        print(num, "is a prime number")
else:
    print(num, "is not a prime number")

#10.  BMI Calculator : Write a program that calculates the Body Mass Index (BMI) and categorizes it.

def BMI(height, weight):
    bmi = weight/(height**2)
    return bmi


height = 1.79832
weight = 70
bmi = BMI(height, weight)

print("The BMI is", format(bmi), "so ", end='')


if (bmi < 18.5):
    print("underweight")

elif ( bmi >= 18.5 and bmi < 24.9):
    print("Healthy")

elif ( bmi >= 24.9 and bmi < 30):
    print("overweight")

elif ( bmi >=30):
    print("Suffering from Obesity")

#11. Divisibility Check :  Write a Python program that checks if a number is divisible by 3, 5, or both.
num=int(input("enter a number: "))
if num%3==0 and num%5==0:
  print(f"{num} is divisible by both 3 and 5")
elif num%3==0:
  print(f"{num} is divisible by 3")
elif num % 5 ==0:
  print(f"{num} is divisible by 5")
else:
  print("invalid")

#12. Quadratic Equation Solver:  Write a Python program that solves quadratic equations (ax^2 + bx + c = 0) and displays the roots.
#(ax^2 + bx + c = 0)

a=int(input("enter a number: "))
b=int(input("enter a number: "))
c=int(input("enter a number: "))