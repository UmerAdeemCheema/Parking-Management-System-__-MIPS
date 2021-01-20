.data
.align 2
cararray: .space 40
bikearray1: .space 40
bikearray2: .space 40
 

displaymainmenu: .asciiz "\n   _______________________________________________\n  |               Choose your Option              |\n  |_______________________________________________|\n  |                                               |\n  |  1) Arrival of a Vehicle                      |\n  |  2) No. of Vehicles Parked                    |\n  |  3) Display Order of Vehicles Parked          |\n  |  4) Departure of a Vehicle                    |\n  |                                               |\n  |  5) Exit                                      |\n  |_______________________________________________|\n      Enter your choice : "
mainmenuend: .asciiz "  |_______________________________________________|\n"
contPrompt: .asciiz "\n Press ENTER to continue..."
password: .asciiz "\n  !!PASSWORD!!\n  Enter the PIN code to continue : "
loginsuccessfull: .asciiz "\n  Log in Successful....\n"
invalidpassword: .asciiz "\n  Invalid Password....\n"
arrivalmenu: .asciiz "\n------------------------------------------------------------\n                         ARRIVAL\n------------------------------------------------------------\n     For Car press 1\n     For a Bike press 2\n     Enter your vehicle type: "
arrivalmenuend: .asciiz "\n------------------------------------------------------------\n"
inputplatenumber: .asciiz "\n     Enter Plate number of the vehicle: "
alreadypresentplatenumber: .asciiz "\n              !!!WRONG PLATE NO.!!!\n    !!!PLATE NO. ALREADY IN THE PARKING!!!\n"
inputerror: .asciiz "\n    !!!WRONG INPUT!!!"
inputhourstobeparked: .asciiz "\n     Enter hours you will park your vehicle: "
feeofparking: .asciiz "\n     Fee of Parking : "
parkingfull: .asciiz "\n      Parking Space is Full come back later.....\n"
displaynumberofvehicles: .asciiz "\n   __________________________________________\n  |             Vehicles Parked              \n  |__________________________________________|\n\n      Total no. of vehicles Parked: "
displaycars: .asciiz "\n\n      Cars Parked: "
displaybikes: .asciiz "\n      Bikes Parked: "
displaynumberend: .asciiz "\n   __________________________________________\n"
displayorder: .asciiz "\n------------------------------------------------------------\n                  ORDER OF VEHICLES PARKED\n------------------------------------------------------------\n  CAR PARKING AREA:\n"
displayorderbikes: .asciiz "\n\n  BIKE PARKING AREA:\n"
gap:.asciiz "    "
displayorderend: .asciiz "\n------------------------------------------------------------\n "
newLine: .asciiz "\n"
departuremenu: .asciiz "\n------------------------------------------------------\n                     DEPARTURE\n------------------------------------------------------\n\n     For Car press 1\n     For a Bike press 2\n     Enter your vehicle type:"
GoodBye: .asciiz "\n      ---------------------------------------\n     |             !!!GOOD BYE!!!            |\n     |         !!!SEE YOU NEXT TIME!!!       |\n     |            ##MNN JAAN BAAZM#          |\n      ---------------------------------------\n"
noRecord: .asciiz "\n    !!!WRONG PLATE NO. ENTERED!!!\n        !!!NO RECORD FOUND!!!\n"
parkingempty: .asciiz "\n      Parking Space is empty.....\n"
parkingnotempty: .asciiz "\n     !!!There are still Vehicles in the Parking!!!\n                  !!!Can't Shutdown!!!\n"

.text
Main:
li $v0,4
la $a0,password   # System wil ask for password
syscall

li $v0,5    # Input password
syscall


beq $v0, 1111, initializearrays    # if password is correct i.e. '1111' branch to initialize arrays

li $v0,4
la $a0,invalidpassword            # else print 'invalid password'
syscall

b Main                             # again ask password.

initializearrays:
li $s1, 0                    #tOTAL NUMBER OF CARS present IN PARKING
li $s2, 0                    #Total number of bikes present in parking

li $v0,4
la $a0,loginsuccessfull      # print that the login was successfull.
syscall

li $t0, 0               # the controller of iteration that will be from 0 to 10
li $t1,0                # contains value '0' which will be stored into the arrays

initializeloop:
beq $t0, 40, MainMenu      # when the loop has ran 10 times branch to main menu
Sw $t1,cararray($t0)       # initialize the car array, which will contain the plate number of cars parked, with '0'
Sw $t1,bikearray1($t0)     # initialize the bike array, which will contain the plate number of bikes parked in Row 1, with '0'
Sw $t1,bikearray2($t0)     # initialize the bike array, which will contain the plate number of bikes parked in Row 2, with '0'
addi $t0, $t0, 4
b initializeloop

MainMenu:
li $v0,4
la $a0,displaymainmenu     # display the main menu and ask to choose an option
syscall

li $v0,5                   # input an option
syscall

la  $t2, ($v0)

li $v0,4
la $a0,mainmenuend
syscall

beq $t2, 1, arrival                          # if option choosen is one go to the procedure for arrival of vehical
beq $t2, 2, numberofvehiclesparked           # else if option choosen is two go to the procedure for telling the information about the total number of vehicals parked
beq $t2, 3, displayorderofvehiclesparked     # else if option choosen is three go to the procedure for displaying the plate numbers of the vehicals and where are they parked.
beq $t2, 4, departure                        # else if option choosen is four go to the procedure for departure of vehical
beq $t2, 5, exit                             # else if option choosen is five go to the procedure for exitting the parking system

li $v0, 4
la $a0, inputerror                    # else print an error
syscall

b enter                              # and branch to the enter function

arrival:
li $v0, 4
la $a0, arrivalmenu         # will print and ask option to select the vehicle type
syscall

li $v0,5                    # will take the input of the option
syscall

la  $t2, ($v0)

li $v0, 4
la $a0, arrivalmenuend
syscall

beq $t2, 1, arrivalcheckincars     # if the input is one i.e. car branch to the function
beq $t2, 2, arrivalcheckinbikes    # else if the input is two i.e. bike branch to the function

li $v0, 4
la $a0, inputerror                 # else print error and branch to the 'enter' function
syscall

b enter

arrivalcheckincars:
beq $s1, 10, vehicletypeparkingfull   # if the capacity of cars in parking i.e. 10 is reached branch to function

li $v0, 4
la $a0, inputplatenumber              # else take input of the plate number
syscall

li $v0,5                              
syscall

la $t9, ($v0)                         # save the plate number in register t9

beq $t9, 0, enteredzeroinplatenumber  # if the entered plate number is equal to zero branch to function

checkifalreadypresentincararray:     # else proceed through this procedure
li $t0, 0

checkforcarpresentloop:           # this function will check if there is any vehicle already present with the same entered number plate
beq $t0, 40, putincars            # if the loop has been iterated 10 times branch to putincar function
lw $t1,cararray($t0)
beq $t9, $t1, platenumberalreadypresent  # if the entered plate no. = already present plate no.
addi $t0, $t0, 4
b checkforcarpresentloop

arrivalcheckinbikes:
beq $s2, 20, vehicletypeparkingfull  # if the capacity of cars in parking i.e. 20 is reached branch to function

li $v0, 4
la $a0, inputplatenumber             # else take input of the plate number
syscall

li $v0,5
syscall

la $t9, ($v0)                         # save the plate number in register t9

beq $t9, 0, enteredzeroinplatenumber  # if the entered plate number is equal to zero branch to function

checkifalreadypresentinbikearray:      # else proceed through this procedure
li $t0, 0

checkforbikepresentloop:             # this function will check if there is any vehicle already present with the same entered number plate
beq $t0, 40, putinbikes              # if the loop has been iterated 10 times branch to putincar function
lw $t1,bikearray1($t0)
lw $t3,bikearray2($t0)
beq $t9, $t1, platenumberalreadypresent  # if the entered plate no. = already present plate no.
beq $t9, $t3, platenumberalreadypresent  # if the entered plate no. = already present plate no.
addi $t0, $t0, 4
b checkforbikepresentloop

vehicletypeparkingfull:
li $v0, 4
la $a0, parkingfull            # if the vehicle parking for the vehicle type is full print message
syscall

b enter

putincars:
li $v0, 4
la $a0, inputhourstobeparked   # ask to input no. of hours for which the vehicle will be parked
syscall

li $v0,5
syscall

la $t4, ($v0)

li $v0, 4
la $a0, feeofparking        # print the message for showing fee of parking
syscall

li $t3, 50
mult $t4, $t3             # multiply hours by 50 (for cars) to obtain the fee
mflo $t4
li $v0, 1
move $a0, $t4
syscall                  # print the fee

putincararray:           # this function will search for a place which is empty for parking (0 in the array shows that the place is empty)
li $t0, 0
putincararrayloop:   
beq $t0, 40, enter    
lw $t1,cararray($t0)     
beq $t1, 0, putoncararray   # if the data at the index of array is 0 go to function
addi $t0, $t0, 4
b putincararrayloop

putoncararray:
Sw $t9, cararray($t0)      # array[index] = plate number
addi $s1,$s1,1             # increment the total number of cars present with 1

li $v0, 4
la $a0, arrivalmenuend

syscall
b enter

putinbikes:
li $v0, 4
la $a0, inputhourstobeparked    # ask to input no. of hours for which the vehicle will be parked
syscall

li $v0,5
syscall

la $t4, ($v0)

li $v0, 4
la $a0, feeofparking          # print the message for showing fee of parking
syscall

li $t3, 20
mult $t4, $t3               # multiply hours by 20 (for bikes) to obtain the fee
mflo $t4
li $v0, 1
move $a0, $t4
syscall                   # print the fee

putinbikearray1:           # this function will search for a place which is empty for parking (0 in the array shows that the place is empty)
li $t0, 0
putinbikearray1loop:
beq $t0, 40, putinbikearray2  # if the row1 bike array has been completely traversed branch to check any empty space in row 2 bikearray
lw $t1,bikearray1($t0)
beq $t1, 0, putonbikearray1     # if the data at the index of array is 0 go to function
addi $t0, $t0, 4
b putinbikearray1loop

putinbikearray2:
li $t0, 0
putinbikearray2loop:
beq $t0, 40, enter
lw $t1,bikearray2($t0)
beq $t1, 0, putonbikearray2     # if the data at the index of array is 0 go to function
addi $t0, $t0, 4
b putinbikearray2loop

putonbikearray1:
Sw $t9, bikearray1($t0)     # array[index] = plate number
addi $s2,$s2,1             # increment the total number of bikes present with 1

li $v0, 4
la $a0, arrivalmenuend
syscall

b enter

putonbikearray2:
Sw $t9, bikearray2($t0)     # array[index] = plate number
addi $s2,$s2,1             # increment the total number of bikes present with 1

li $v0, 4
la $a0, arrivalmenuend
syscall

b enter

platenumberalreadypresent:
li $v0, 4
la $a0, alreadypresentplatenumber  # print message if plate number is already present in parking
syscall

b enter

enteredzeroinplatenumber:
li $v0, 4
la $a0, inputerror  # print message if plate number entered is '0'
syscall

b enter

numberofvehiclesparked:
li $v0, 4
la $a0, displaynumberofvehicles
syscall

add $t0,$s1,$s2     # add the total number of vehicles (both cars and bikes) and print them
li $v0,1
add $a0,$zero,$t0
syscall

li $v0, 4
la $a0, displaycars
syscall

li $v0, 1
move $a0, $s1    # display number of cars present in the parking
syscall

li $v0, 4
la $a0, displaybikes
syscall

li $v0, 1
move $a0, $s2   # display number of bikes present in the parking
syscall

li $v0, 4
la $a0, displaynumberend
syscall

b enter

displayorderofvehiclesparked:
li $v0, 4
la $a0, displayorder
syscall
b displayordercars

displayordercars:     # display the array of cars
li $t0, 0
li $v0, 4
la $a0, gap
syscall
Whilecars:
beq $t0, 40, displaybikes1 
lw $t6,cararray($t0)
addi $t0, $t0,4
li $v0,1
move $a0, $t6
syscall
li $v0, 4
la $a0, gap
syscall
j Whilecars

displaybikes1:       # display the array of bikes row 1
li $v0, 4
la $a0, displayorderbikes
syscall
li $t0, 0
li $v0, 4
la $a0, gap
syscall
Whilebikes1:
beq $t0, 40, displaybikes2
lw $t6,bikearray1($t0)
addi $t0, $t0,4
li $v0,1
move $a0, $t6
syscall
li $v0, 4
la $a0, gap
syscall
j Whilebikes1

displaybikes2:       # display the array of bikes row 2
li $t0, 0

li $v0, 4
la $a0, newLine
syscall

li $v0, 4
la $a0, gap
syscall

Whilebikes2:
beq $t0, 40, displayend
lw $t6,bikearray2($t0)
addi $t0, $t0,4
li $v0,1
move $a0, $t6
syscall
li $v0, 4
la $a0, gap
syscall
j Whilebikes2

displayend:
li $v0, 4
la $a0, displayorderend
syscall

b enter

departure:
li $v0, 4
la $a0, departuremenu    # print to ask which vehicle type will be departing
syscall

li $v0,5            # take input of vehicle type
syscall

la  $t2, ($v0)

li $v0, 4
la $a0, arrivalmenuend
syscall

beq $t2, 1, departurecheckincars   # if the vehicle type entered is car branch to the function
beq $t2, 2, departurecheckinbikes  # else if the vehicle type entered is bike branch to the function 

li $v0, 4
la $a0, inputerror  # else print error message
syscall

b enter

departurecheckincars:
beq $s1, 0, parkingempty  # if the number of cars present in parking is zero branch

li $v0, 4
la $a0, inputplatenumber # input the plate number
syscall

li $v0,5
syscall

la $t9, ($v0)

beq $t9, 0, enteredzeroinplatenumber # if entered plate number is '0' branch

checkingthepositionofcar:  # check the array for a match with the entered plate number
li $t0, 0

checkforpositionofcarloop:
beq $t0, 40, notpresent  # if the end of loop is reached branch to function
lw $t1,cararray($t0)     
beq $t9, $t1, deletecar  # if array[index] = register t9, branch
addi $t0, $t0, 4
b checkforpositionofcarloop

deletecar:
li $t6, 0
Sw $t6,cararray($t0)   # array[index] = 0

addi $s1,$s1,-1   # 1 will be subtracted from the number of cars present in the parking

li $v0, 4
la $a0, GoodBye # Good Bye will be printed
syscall

b enter

departurecheckinbikes:
beq $s2, 0, parkingempty  # if the number of bikes present in parking is zero branch

li $v0, 4
la $a0, inputplatenumber  # input the plate number
syscall

li $v0,5
syscall

la $t9, ($v0)

beq $t9, 0, enteredzeroinplatenumber # if entered plate number is '0' branch

checkingthepositionofbike1:
li $t0, 0

checkforpositionofbike1loop:
beq $t0, 40, checkingthepositionofbike2  # if the end of loop is reached branch to check row 2 array of bikes
lw $t1,bikearray1($t0)
beq $t9, $t1, deletebike1  # if array[index] = register t9, branch
addi $t0, $t0, 4
b checkforpositionofbike1loop

deletebike1:
li $t6, 0
Sw $t6,bikearray1($t0)   # array[index] = 0

addi $s2,$s2,-1   # 1 will be subtracted from the number of bikes present in the parking

li $v0, 4
la $a0, GoodBye # Good Bye will be printed
syscall

b enter

checkingthepositionofbike2:
li $t0, 0

checkforpositionofbike2loop:
beq $t0, 40, notpresent  # if the end of loop is reached branch to function
lw $t1,bikearray2($t0)
beq $t9, $t1, deletebike2  # if array[index] = register t9, branch
addi $t0, $t0, 4
b checkforpositionofbike2loop

deletebike2:
li $t6, 0
Sw $t6,bikearray2($t0)   # array[index] = 0

addi $s2,$s2,-1   # 1 will be subtracted from the number of bikes present in the parking
li $v0, 4
la $a0, GoodBye # Good Bye will be printed
syscall

b enter

notpresent:
li $v0, 4
la $a0, noRecord # print message that the number plate is not present in the parking
syscall

b enter

parkingisnotempty:
li $v0, 4
la $a0, parkingnotempty # print that th eparking is not empty to shut the system down
syscall

b enter

enter:   # Code for press enter to continue
li $v0, 4
la $a0, contPrompt  
syscall

li $v0, 12 # sys code for readchar
syscall

move $t0, $v0

b MainMenu

exit:
bnez $s1, parkingisnotempty  # if car present in parking is not equal to zero, branch
bnez $s2, parkingisnotempty  # else if bikes present in parking is not equal to zero, branch

li $v0, 10  # end the program