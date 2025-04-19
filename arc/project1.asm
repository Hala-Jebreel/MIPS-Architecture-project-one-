# Data Section
.data
frame: .asciiz "\n*********************************************Medical Tests*******************************************************\n"
Menu: .asciiz "\n Choose an operation or -1 to exit program please:\n1- Add a new medical test.\n2- Search for a test by patient ID.\n3- Searching for unnormal tests.\n4- Average test value.\n5- Update an existing test result.\n6- Delete a test.\n"
option2: .asciiz "\n Which option do you want? \n 1- Retrieve all patient tests. \n 2- Retrieve all up normal patient tests. \n 3- Retrieve all patient tests in a given specific period.\n"
fileName: .asciiz "C:\\Users\\1\\Desktop\\ARC_FOLDER\\arc\\filee.txt"
fileSpace: .space 1024 #to hold all the words in the file 
Error: .asciiz "Error in oppening the file\n"
Success: .asciiz "Sucessful oppenenig \n"
otherOperations: .asciiz "No such operation! Please enter a valid operation.\n"
unValidName_error: .asciiz "\nError! unvalid test name. Please try again."
DigitsID_error: .asciiz "Error! the ID must be an integer and without any characters and mustn't be <=0 or larger than 7 digits. Please try again."
prompt_Data: .asciiz "Please enter the required data-> patient ID: test name, test date, result.\n"
input_buffer: .space 60        # Buffer to store the input string
line_break: .asciiz "\n"            # Newline character
extracted_digits: .space 10        # Buffer to store the extracted characters (including null terminator)
validID_message: .asciiz "Valid ID\n"
name1: .asciiz " Hgb"   # First test name
name2: .asciiz " BGT"   # Second test name
name3: .asciiz " LDL"   # Third test name
name4: .asciiz " BPT"   # Fourth test name
name5: .asciiz " RBC"   # Fifth test name
validName_message: .asciiz "Valid name\n" # Test name is valid and it matches one of the previous 5 test names
unvalidName_message: .asciiz "Invalid test name, please try again.\n"
extracted_chars: .space 10        # Buffer to store the test name extracted from a line in the file (including null terminator)
promptID: .asciiz "Please enter the patient ID.\n" 
input_buffer_ID: .space 10 # A buffer to store the ID entered by the user
line_buffer: .space 1024 # A buffer to hold character by character from the text file
extracted_digits_ID: .space 8        # Buffer to store the extracted ID from  line in the file (including null terminator)
lines: .space 50  #A buffer to hold each line of the text file
date_buffer: .space 10       # Buffer to store the date string (YYYY-MM)
prompt_startDate: .asciiz "\nEnter the start date (YYYY-MM): "
prompt_endDate: .asciiz "\nEnter the end date (YYYY-MM): "
patientID_not_matched: .asciiz "Patient ID not found in the records."
start_date_year:      .space 10    # Reserve space for the start date buffer
end_date_year:      .space 10     # Reserve space for the end date buffer
integer_value: .word 0 # A buffer to store the integer part of the test result 
fractional_value: .word 0 # A buffer to store the fractional part of the test result 
fraction_constant: .float 0.1 # A constant to devide fractional part by 10 according to number of digits after '.'
zero_float: .float 0.0 # A constant to points to end of dividing fractional part by 10
# Normal ranges of each medical tests
Hgb_min: .float 13.8 
Hgb_max: .float 17.2
RBC_min: .float 4.2
RBC_max: .float 6.1
BGT_min: .float 70.0 
BGT_max: .float 99.0
LDL_max: .float 100.0
BPT_Sytolic_max: .float 120.0 
BPT_Diastolic_max: .float 80.0 
flag_foundID:   .word 0   # Flag variable to check if searched ID was found, initially set to 0
unfoundID: .asciiz "\nError! the required ID is not found. Please try again.\n" 
unfoundtestName: .asciiz "\nError! the test name is invalid. Please try again.\n"
# Buffers to store sum of each test, to compute average 
Hgb_sum: .float 0.0	
RBC_sum: .float 0.0
BGT_sum: .float 0.0
LDL_sum: .float 0.0
BPT_sum1: .float 0.0
BPT_sum2: .float 0.0
# Buffers to store count of each test, to compute average 
Hgb_count: .word 0   
BGT_count: .word 0   
LDL_count: .word 0
RBC_count: .word 0
BPT_count: .word 0
integer_part: .word 0 # A buffer to store the integer part of the second test result in case of 'BPT' 
fractional_part: .word # A buffer to store the fractional part of the second test result in case of 'BPT' 
Hgb_average: .asciiz "\nAverage value of Hgb test:\n"
BGT_average: .asciiz "\nAverage value of BGT test:\n"
LDL_average: .asciiz "\nAverage value of LDL test:\n"
RBC_average: .asciiz "\nAverage value of RBC test:\n"
BPT_Systolic_average: .asciiz "\nAverage value of sytolic BP test:\n"
BPT_Diastolic_average: .asciiz "\nAverage value of diastolic BP test:\n"	
input_buffer_count: .word 0   	
is_BPT: .word 0	    
delete_line: .asciiz "\nEnter the number of the line you want to delete, please. \n"	
lines_of_file: .word 0    	
input_StartDate_without: .space 7
input_EndDate_without: .space 7
extracted_date_without: .space 7
modified_file: .space 2048
update_line: .asciiz "\nEnter the number of the line you want to update, please. \n"	
prompt_newResult: .asciiz "\nEnter the new test result, please. \n"
userNewinput: .space 50
final_buffer: .space 100
validDateMessage: .asciiz "Valid Date\n"
InvalidDateMessage: .asciiz "Invalid date, the date must not have any letters and must be only 6 digits and the month must be between 01 and 12! \n" 
validtestResult: .asciiz "Valid test result\n"
InvalidtestResult: .asciiz "Invalid test result, the result must not have any letters! \n" 
extracted_month: .space 8
foundTests: .word 0 
noTestsFound: .asciiz "\nNo tests found.\n"
# Code Section
.text
.globl main
main: 
	la $a0, fileName
	li $a1, 0 #file flag = read (0) (read=0, write=1)
	jal open_file 	#read the file:
	la $a1, fileSpace #The buffer that holds the lines of the text file

	reading:  # Loop to read the test file character by character and store them in the 'fileSpace' buffer
		jal read_file_character # Calling 'read_file_character' method to read each character in the file 
		beqz $v0, endofFile # checking if end of file is reached
		lb $t3, 0($a1)
		addi $a1, $a1, 1 # move to next character in the file
	j reading

	endofFile:
		# Close the file
		jal closing_file
		la $a0, fileSpace 
	jal print_file # Calling 'print_file' method to print the lines of the file 

	back:
		la $a0, frame 
		jal print_string #Calling 'print_string' method to print 'frame' string 
		la $a0, Menu
		jal print_string 
		li $v0,5 #It will stop to take the user's input which will be stored in v0
		syscall
		move $t0, $v0 
		# Checking the user's choice to determine the required operation
		beq $t0, 1,first_operation
		beq $t0, 2,second_operation
		beq $t0, 3,third_operation
		beq $t0, 4,fourth_operation
		beq $t0, 5,fifth_operation
		beq $t0, 6,sixth_operation
		bgt $t0, 6, unFound
		blt $t0, 1, unFound
		bne $t0, -1, back
	
	unFound: # If the user chose another operation, an error message will appear and the program will end 
		beq $t0, -1, end_Program 
		li $v0,4
		la $a0, otherOperations
		syscall 
	j back # Repeat the previous operations 
#---------------------------------------------------------First Function----------------------------------------------------------------
first_operation: # The user wants to add a new medical test 
	li $t0, 0
	la $t1, input_buffer_count # $t1 points to 'input_buffer_count'
	sw $t0, 0($t1) # Clear the 'input_buffer_count'
	la $a0, fileName
	li $a1, 9
	li $a2, 1 #file flag = read (0) (read=0, write=1)
	jal open_file 
	
	writing:
		la $a0, prompt_Data # Ask the user to enter the required data to store in the file 
		jal print_string 
		li $v0, 8                 # System call code for reading a string from the user 
		la $a0, input_buffer      # Load the address of the input buffer
		li $a1, 60               # Maximum number of characters to read
		syscall                   # Read the input string
		# Count the number of characters of the input string to indicate how many characters to write to the file 
		li $t0, 0               # Initialize character count to zero
		la $t1, input_buffer    # Load address of the input buffer
	count_loop:
		lb $t2, 0($t1)          # Load a byte from the string
		beq $t2, $zero, end_count   # If null terminator is reached, end counting characters 
		addi $t0, $t0, 1        # Increment character count
		addi $t1, $t1, 1        # Move to the next character
	j count_loop            # Repeat the loop
	end_count:
		la $t2, input_buffer_count
		sb $t0,0 ($t2) # Storing the count of characters in 'input_buffer_count'
		la $a0, input_buffer          # Load the address of the input buffer
		la $a1, extracted_digits      # Load the address of the buffer to store extracted digits
		jal extract_ID 		# Extract the first seven characters from the input buffer which hold the patient ID 
		la $a0, extracted_digits  
		jal str2int 		# Convert the extracted ID to an integer
		move $t0,  $v0 # $t0 hold the ID as an integer 
		blez $t0, inValidID # Checking if the ID is less than or equal to 0 and so invalid 
		ble $t0, 999999, inValidID # Checking if the ID is less than 7 digits
		bge $t0, 10000000, inValidID # Checking if the ID is more than 7 digits
		la $a0, extracted_digits  
		jal check_only_digits  # Checking if the ID has any letters
		bne $t0,1,inValidID 
		beq $t5, 1, inValidID #Checking if the id is a floating point number 
		la $a0, validID_message 
		jal print_string
		la $a0, input_buffer          # Load the address of the input buffer
		jal extractName  # Extract test name from the input buffer to check validity 
		
		la $a0, name1
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match1

		la $a0, name2
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match2

		la $a0, name3
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match3

		la $a0, name4
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match4

		la $a0, name5
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match5
		
		# No match found
		j no_match
		
	found_match1:
		ValidTestName: 
		la $a0,validName_message
		jal print_string 
	j checkinputDate # Check if the date in the input buffer is valid
		
	found_match2:
	j ValidTestName
	
	found_match3:
	j ValidTestName 
	
	found_match4:
	j ValidTestName 
	
	found_match5:
	j ValidTestName 
	
	no_match: # Error messageif the test name is invalid 
		la $a0, unvalidName_message
		jal print_string 
	j close_file 

	checkinputDate: 
		la $t0, input_buffer  
		jal extractDate # Extract test date from the input buffer entered by the user 
		la $a0, date_buffer 
		jal extractMonth # Extract month from the extracted date 
		la $a0, extracted_month 
		jal str2int # Converting the extracted month to an integer 
		move $t1, $v0
		li $t2, 12 
		li $t3, 0
		ble $t1, $t3, inVlidDate # If the month in date buffer <=0 so it is invalid 
		bgt $t1, $t2, inVlidDate  # If the month in date buffer > 12 so it is invalid 
		
		la $a0, date_buffer
		la $a1, extracted_date_without
		jal convert_without_dash # Removing '-' from the extracted date 
		la $a0, extracted_date_without
		addi $a0, $a0, 1
		jal check_only_digits # Checking if the date contains only integers without letters 
		bne $t0,1,inVlidDate # Checking if the date contains only integers without floating point numbers 
		beq $t5, 1, inVlidDate 
		la $a0, extracted_date_without
		jal str2int
		move $t0, $v0 
		
		blez $t0, inVlidDate
		ble $t0, 99999, inVlidDate # If the date is less than 6 digits so it is invalid 
		bge $t0, 1000000, inVlidDate # If the date is more than 6 digits so it is invalid 
		la $a0, validDateMessage
		jal print_string 
	j checkForResult # Checking the validity of the test result 
	
	inVlidDate: 
		la $a0, InvalidDateMessage
		jal print_string 
	j close_file 

	checkForResult: 
		la $t0, input_buffer 
		jal extractDate # Extract date from the input buffer 
		addi $t0 $t0, 2 # Now the pointer $t0 points to first digit in the input buffer 
		move $a0, $t0
	#	jal print_string 
		jal check_only_digits # Checking if the test result contains any letters 
		beqz $t0, invalidTestResult

		la $a0, validtestResult
		jal print_string 
	j storeToFile # If test result is valid so the input buffer is valid and so store it in the text file 
	
	invalidTestResult: 
		la $a0, InvalidtestResult
		jal print_string 
		
	close_file:	
		#close the file 
		li $v0, 16
		move $a0, $s0 #file descriptor to close 
		syscall
	j back
	
	storeToFile: 
		la $t0, input_buffer_count # Number of characters to store 
		lw $t1, 0($t0)
		li $v0, 15                # System call code for write to file
		move $a0, $s0             # File handle
		la $a1, input_buffer      # Load the address of the input buffer
		move $a2, $t1
		syscall                   # Write the string into the file
	j close_file 
	
	inValidID: 
		la $a0, DigitsID_error
		jal print_string
	j close_file # Closing the file 
#---------------------------------------------------------Second Function----------------------------------------------------------------
second_operation:
	la $a0, lines
	jal clear_buffer # Clear the previous stored line from the file 
	la $a0, extracted_digits_ID 
	jal clear_buffer # Clear the previous stored ID 
	jal clear_results
	sw $zero, flag_foundID # Clear the flag so the ID is initially unfound
	sw $zero, foundTests # Clear the 'foundTest' flag so initially no tests found
	la $a0, option2 # Printing the choices of the second operation
	jal print_string 
	li $v0,5 # It will stop to take the user's input which will be stored in v0
	syscall
	
	move $t0, $v0
	# Checking the user's choice to determine the required operation
	beq $t0, 1,first_choice
	beq $t0, 2,second_choice
	beq $t0, 3,third_choice
#****************************************************************************************
	first_choice:
		la $a0, fileName         # Load file name
		li $a1, 0                 # Read mode (read-only)
		jal open_file
		jal start_of_second_operation # Asking for required ID subroutin 
		
		# Iterate through the file to find matches
		la $a1, line_buffer       # Load line buffer address
		li $t9, 0
		
	read_file_loop:
		jal read_file_character
		beq $v0, $zero, end_of_file  # If end of file, exit loop
		lb $t5, 0($a1)
		beq $t5, '\n', start # If a line is stored, the process starts 
		sb $t5, lines($t9)
		addi $t9, $t9, 1
	j read_file_loop 
	
	start:
		sb $zero, lines($t9)              # Null-terminate the output buffer
		la $a0, lines        # Load the address of the input buffer
		la $a1, extracted_digits_ID      # Load the address of the buffer to store extracted ID
		jal extract_ID
		# Compare the extracted patient ID with the ID entered by the user
		move $a0, $s1             # User input buffer address
		la $a1, extracted_digits_ID             # Extracted patient ID address
		jal beq_string       # Calling 'beq_string' subroutine to compare strings
		li $t9,0
	beq $v0, 0, read_file_loop  # If no match, continue reading the next line	
		li $t0, 1
		la $t1,  flag_foundID 	# If a match is found, set the flag 
		sw $t0, 0($t1) 
		
		# Print a newline character to separate lines
		la $a0, line_break        # Load the address of the newline character
		jal print_string    
		la $a0, lines     	# If a match is found, print the test information
		jal print_string
		
		# Continue reading the next line
		li $t9,0
	j read_file_loop

	end_of_file: 
		# Close the file
		li $v0, 16                # Close syscall code
		move $a0, $s0             # File descriptor
		syscall
		la $t1, flag_foundID
		lw $t2, 0($t1)
		beqz $t2, unfoundID_message  # If the flag remains 0 so the ID is not found 
	j back 
	
	unfoundID_message: 
		la $a0, unfoundID
		jal print_string
	j back
#****************************************************************************************
	second_choice:
		la $a0, fileName         # Load file name
		li $a1, 0                 # Read mode (read-only)
		jal open_file
		jal start_of_second_operation
		
		# Iterate through the file to find matches
		la $a1, line_buffer     # Load line buffer address
		li $t9, 0
		
	read_file_loop_sc:
		jal read_file_character
		beq $v0, $zero, end_of_file_sc  # If end of file, exit loop
		lb $t5, 0($a1)
		beq $t5, '\n', start_sc 
		sb $t5, lines($t9)
		addi $t9, $t9, 1
	j read_file_loop_sc 
	
	start_sc:
		sb $zero, lines($t9)              # Null-terminate the output buffer
		jal clear_results
		la $a0, lines        # Load the address of the input buffer
		la $a1, extracted_digits_ID      # Load the address of the buffer to store extracted digits
		jal extract_ID
		
	# Compare the extracted patient ID with the ID entered by the user
		la $a0, input_buffer_ID            # User input buffer address
		la $a1, extracted_digits_ID             # Extracted patient ID address
		jal beq_string       # Jump to subroutine to compare strings
		
		li $t9,0
		beq $v0, 0, read_file_loop_sc  # If no match, continue reading the next line

	# If a match is found, check the test name and test result		
		jal set_flag 
		
		la $a0, lines
		jal extractName
		
		la $a0, lines
		jal extract_testResult
		
		la $a0, integer_value
		jal str2int 
		move $t3, $v0
		
		la $a0, fractional_value 
		jal str2int 
		move $t4, $v0 #t4 contains fractional part
		
		la $a0, integer_part
		jal str2int 
		move $t5, $v0
		
		la $a0, fractional_part 
		jal str2int 
		move $t6, $v0 #t6 contains fractional part of the next result in case of 'BPT' test 
		
		move $a0, $t3
		jal converttoFloat
		mov.s $f2, $f0 # $f2 hold the integer part of the result as a floating point number 
		
		move $a0, $t4
		jal converttoFloat
		mov.s $f3, $f0 # $f3 hold the frzctional part of the result as a floating point number 
		
		move $a0, $t5
		jal converttoFloat
		mov.s $f6, $f0 # $f6 hold the integer part of the next result as a floating point number 
		
		move $a0, $t6
		jal converttoFloat
		mov.s $f7, $f0 # $f2 hold the fractional part of the next result as a floating point number 
		
		jal countDigits_method # A method to count the digits after '.' 
		jal complete_converting # A method to return the final test result converted to floating point number 
		
	# Compare the substring against each of the five specific names
		la $a0, name1
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match1_sc

		la $a0, name2
		la $a1, extracted_chars	
		jal beq_string
		beq $v0, 1 , found_match2_sc

		la $a0, name3
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match3_sc

		la $a0, name4
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match4_sc

		la $a0, name5
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match5_sc

		la $a0, unValidName_error
		jal print_string
		j back
#--------------------------------------------------------------------------
	found_match1_sc:
		la $t0, is_BPT   
		sw $zero, ($t0)	# Clear 'is_BPT' flag as 'BPT' test requires another treatment 	    	
		l.s $f12, Hgb_max
		l.s $f15, Hgb_min 
	max_min_checking: # Comparing test result with minimum and maximum values of each test 
		la $a0, lines
		jal check_unnormal 
		li $t9, 0
		la $a1, line_buffer
	j read_file_loop_sc 
	 
	common: #Comparing test results with only maximum value in case of 'LDL' and 'BPT '
		la $a0, lines
		jal check_upnormal # Cheking if the test result > normal range  
		li $t9,0
		la $a1, line_buffer 
	j read_file_loop_sc # Checking next lines 
#--------------------------------------------------------------------------
	found_match2_sc:  
		la $t0, is_BPT   
		sw $zero, ($t0)	 # Clear 'is_BPT' flag as 'BPT' test requires another treatment 
		l.s $f12, BGT_max
		l.s $f15, BGT_min
	j max_min_checking  # Repeat previous steps 
#--------------------------------------------------------------------------
	found_match3_sc: 	 
		la $t0, is_BPT   
		sw $zero, ($t0)	# Clear 'is_BPT' flag as 'BPT' test requires another treatment 
		l.s $f12, LDL_max
	j common  # Repeat previous steps 
#--------------------------------------------------------------------------
	found_match4_sc: 
		li $t1, 1
		la $t0, is_BPT   
		sw $t1, ($t0) # Setting 'is_BPT' flag  
		
		l.s $f12,  BPT_Sytolic_max
		# Converting and comparing second result
		mov.s $f15, $f18	
		mov.s $f2, $f6
		mov.s $f3, $f7
		move $t4,$t6
		jal countDigits_method
		jal complete_converting
		mov.s $f19, $f18
		mov.s $f18, $f15
	j common # Repeat previous steps 
#--------------------------------------------------------------------------
	found_match5_sc:
		la $t0, is_BPT   
		sw $zero, ($t0)	# Clear 'is_BPT' flag as 'BPT' test requires another treatment 
		l.s $f12, RBC_max
		l.s $f15, RBC_min
	j max_min_checking # Repeat previous steps 
#--------------------------------------------------------------------------
	end_of_file_sc : 
		# Close the file
		li $v0, 16                # Close syscall code
		move $a0, $s0             # File descriptor
		syscall
		la $t1, flag_foundID
		lw $t2, 0($t1)
		beqz $t2, unfoundID_message1 # If the flag remains 0 so the ID is not found 
	j checkIffoundTests
	
	unfoundID_message1: 
		la $a0, unfoundID
		jal print_string
	j back
	
		la $t1, flag_foundID
		lw $t2, 0($t1)
		beqz $t2, unfoundID_message
	j back
	
	checkIffoundTests: 
		lw $t2, foundTests
		beqz $t2, noTests_message # If the flag remains 0 so  no upnormal tests are found for the entered ID  
	j back 
	
	noTests_message: 
		la $a0, noTestsFound 
		jal print_string 
	j back 
#****************************************************************************************
	third_choice:
		la $a0, fileName
		li $a1, 0
		jal open_file
		jal start_of_second_operation # Asking for required ID subroutin 
		
		la $a0, prompt_startDate 	# Prompt user to enter start date
		jal print_string
		la $a0, start_date_year             # Read string syscall code
		li $a1, 8
		jal read_string
		
		la $a0, prompt_endDate  # Prompt user to enter end date
		jal print_string
		la $a0, end_date_year             # Read string syscall code
		li $a1, 8
		jal read_string
		
		la $a1, line_buffer   # Load line buffer address
		li $t9, 0
		
	read_file_loop_tc:
		jal read_file_character
		beq $v0, $zero, end_of_file_sc
		lb $t5, 0($a1)
		beq $t5, '\n', start_tc 
		sb $t5, lines($t9)
		addi $t9, $t9, 1
	j read_file_loop_tc     
	
	start_tc:        
		sb $zero, lines($t9)
		la $a0, lines    # Load address of the line buffer
		la $a1, extracted_digits_ID
	jal extract_ID
	
	# Compare the extracted patient ID with the ID entered by the user
		la $a0, input_buffer_ID             # User input buffer address
		la $a1, extracted_digits_ID            # Extracted patient ID address
		jal beq_string       # Jump to subroutine to compare strings
		li $t9,0
	beq $v0, 0, read_file_loop_tc  # If no match, continue reading the next line
	
	# If a match is found:   
		jal set_flag
		
		# Extract date from the line
		la $t0, lines    
		jal extractDate
		la $a0, date_buffer
		la $a1, extracted_date_without
		jal convert_without_dash
		
		#input date 
		la $a0, start_date_year
		la $a1, input_StartDate_without  
		jal convert_without_dash   

		la $a0, end_date_year
		la $a1, input_EndDate_without  
		jal convert_without_dash 

		la $a0, extracted_date_without
		jal str2int
		move $s2, $v0

		la $a0, input_StartDate_without  
		jal str2int 
		move $s3, $v0

		la $a0, input_EndDate_without  
		jal str2int 
		move $s4, $v0
		
		# Check if the date is greater than or equal to the start date
		bge $s2, $s3, check_end_date
		li $t9, 0
	j read_file_loop_tc
	
	check_end_date:
		# Check if the date is less than or equal to the end date
		ble $s2, $s4, print_lines_tc
		li $t9, 0
	j read_file_loop_tc
	
	print_lines_tc:
		li $t0, 1
		sw $t0, foundTests
		la $a0, line_break        # Load the address of the newline character
		jal print_string    
		la $a0, lines     # Load output format string
		jal print_string
		li $t9, 0
	j read_file_loop_tc
#---------------------------------------------------------Third Function----------------------------------------------------------------
	third_operation:
		la $a0, lines
		jal clear_buffer 
		jal clear_results
		sw $zero, foundTests
		la $a0, fileName         # Load file name
		li $a1, 0                 # Read mode (read-only)
		jal open_file
		
	# Iterate through the file to find matches
		la $a1, line_buffer      # Load line buffer address
		li $t9, 0
		
	read_file_loop_to:
		jal read_file_character
		beq $v0, $zero, end_of_file_to  # If end of file, exit loop
		lb $t5, 0($a1)
		beq $t5, '\n', start_to 
		sb $t5, lines($t9)
		addi $t9, $t9, 1
	j read_file_loop_to 
	
	start_to:
		sb $zero, lines($t9)              # Null-terminate the output buffer
		jal clear_results
		la $a0, lines
		jal extractName
		
		la $a0, lines
		jal extract_testResult
		
		la $a0, integer_value
		jal str2int 
		move $t3, $v0 #t3 contains integer part of the test result as an integer 
		
		la $a0, fractional_value 
		jal str2int 
		move $t4, $v0 #t4 contains fractional part of the test result as an integer 
		
		la $a0, integer_part
		jal str2int 
		move $t5, $v0 #t5 contains integer part of the second result in case of 'BPT' as an integer 
		
		la $a0, fractional_part 
		jal str2int 
		move $t6, $v0 #t6 contains fractional part of the second result in case of 'BPT' as an integer 
		
		move $a0, $t3
		jal converttoFloat
		mov.s $f2, $f0 #f2 contains integer part of the test result as a floating point number  
		
		move $a0, $t4
		jal converttoFloat
		mov.s $f3, $f0 #f3 contains fractional part of the test result as a floating point number  
		
		move $a0, $t5
		jal converttoFloat
		mov.s $f6, $f0 #f6 contains integer part of the second test result (in case of 'BPT') as a floating point number  
		
		move $a0, $t6
		jal converttoFloat
		mov.s $f7, $f0 #f7 contains fractional part of the second test result (in case of 'BPT') as a floating point number  
		
		jal countDigits_method # A method to count digits after '.' in the test result 
		jal complete_converting # A method to return the final test result converted to floating point number 
		
	# Compare the substring against each of the five specific names
		la $a0, name1
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match1_to

		la $a0, name2
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match2_to

		la $a0, name3
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match3_to

		la $a0, name4
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match4_to

		la $a0, name5
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1 , found_match5_to
		
		la $a0, unValidName_error
		jal print_string
	j back
#--------------------------------------------------------------------------
	found_match1_to:    
		la $t0, is_BPT   
		sw $zero, ($t0)		
		l.s $f12, Hgb_max
		l.s $f15, Hgb_min
		
	max_min: # Comparing the test result with minimum and maximum values of each test 
		la $a0, lines
		jal check_unnormal
		li $t9,0
		la $a1, line_buffer
	j read_file_loop_to
	
	common_2: # Comparing test results with only maximum value in case of 'LDL' and 'BPT' 
		la $a0, lines
		jal check_upnormal
		li $t9,0
		la $a1, line_buffer
	j read_file_loop_to
#--------------------------------------------------------------------------
	found_match2_to:
		la $t0, is_BPT   
		sw $zero, ($t0)	
		l.s $f12, BGT_max
		l.s $f15, BGT_min
	j max_min
#--------------------------------------------------------------------------
	found_match5_to:
		la $t0, is_BPT   
		sw $zero, ($t0)	
		l.s $f12, RBC_max
		l.s $f15, RBC_min
	j max_min
#--------------------------------------------------------------------------
	found_match3_to:
		la $t0, is_BPT   
		sw $zero, ($t0)	
		l.s $f12, LDL_max
	j common_2
#--------------------------------------------------------------------------
	found_match4_to:
		li $t1, 1
		la $t0, is_BPT   
		sw $t1, ($t0)
		l.s $f12,  BPT_Sytolic_max
		
		mov.s $f15, $f18	
		mov.s $f2, $f6
		mov.s $f3, $f7
		move $t4, $t6 
		jal countDigits_method
		jal complete_converting
		mov.s $f19, $f18
		mov.s $f18, $f15
	j common_2
	
	end_of_file_to: 
		# Close the file
		li $v0, 16                # Close syscall code
		move $a0, $s0             # File descriptor
		syscall
		lw $t2, foundTests
		beqz $t2, noTests_message
	j back 
#---------------------------------------------------------Fourth Function----------------------------------------------------------------
	fourth_operation:
		la $a0, lines
		jal clear_buffer 
		jal clear_results
		# Open the file for reading
		la $a0, fileName         # Load file name
		li $a1, 0                 # Read mode (read-only)
		jal open_file 
		
		la $a1, line_buffer     # Load line buffer address
		li $t9, 0
		
	read_file_loop_foo:
		jal read_file_character
		beq $v0, $zero, end_of_file_foo  # If end of file, exit loop
		lb $t5, 0($a1)
		beq $t5, '\n', start_foo
		sb $t5, lines($t9)
		addi $t9, $t9, 1 
	j    read_file_loop_foo
	
	start_foo: 
		sb $zero, lines($t9)
		#extract test name
		la $a0, lines
		jal extractName
				
		la $a0, lines
		jal extract_testResult
		
		la $a0, integer_value 
		jal str2int 
		move $t3, $v0 #t3 contains integer part of the test result as an integer 
		
		la $a0, fractional_value 
		jal str2int 
		move $t4, $v0 #t4 contains fractional part of the test result as an integer 
		
		la $a0, integer_part
		jal str2int 
		move $t5, $v0 #t5 contains integer part of the second result in case of 'BPT' as an integer 
		
		la $a0, fractional_part 
		jal str2int 
		move $t6, $v0 #t6 contains fractional part of the second result in case of 'BPT' as an integer 
		
		move $a0, $t3
		jal converttoFloat
		mov.s $f2, $f0 #f2 contains integer part of the test result as a floating point number  
		
		move $a0, $t4
		jal converttoFloat
		mov.s $f3, $f0 #f3 contains fractional part of the test result as a floating point number  
		
		move $a0, $t5
		jal converttoFloat
		mov.s $f6, $f0 #f6 contains integer part of the second test result (in case of 'BPT') as a floating point number  
		
		move $a0, $t6
		jal converttoFloat
		mov.s $f7, $f0 #f7 contains fractional part of the second test result (in case of 'BPT') as a floating point number  
		
		jal countDigits_method # A method to count digits after '.' in the test result 
		jal complete_converting # A method to return the final test result converted to floating point number 
		
		la $a0, name1
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1, Hgb

		la $a0, name2
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1, BGT

		la $a0, name3
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1, LDL

		la $a0, name4
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1, BPT

		la $a0, name5
		la $a1, extracted_chars
		jal beq_string
		beq $v0, 1, RBC
		
		la $a0, unValidName_error
		jal print_string
	j back
#--------------------------------------------------------------------------
	Hgb: 
		lw $t0, Hgb_count 
		addi $t0, $t0, 1 # increasing the 'Hgb' test count
		sw $t0, Hgb_count
		mov.s $f1, $f18
		l.s $f2, Hgb_sum 
		add.s $f2, $f2, $f1 # Adding the current test result with the 'Hgb_sum' from previpus lines
		s.s $f2, Hgb_sum
		la $a1, line_buffer     # Load line buffer address
		li $t9, 0
	j    read_file_loop_foo
#--------------------------------------------------------------------------
	BGT:
		lw $t0, BGT_count
		addi $t0, $t0, 1 # increasing the 'BGT' test count
		sw $t0, BGT_count
		mov.s $f1, $f18
		l.s $f2, BGT_sum 
		add.s $f2, $f2, $f1 # Adding the current test result with the 'BGT_sum' from previpus lines
		s.s $f2, BGT_sum
		la $a1, line_buffer     # Load line buffer address
		li $t9, 0
		j    read_file_loop_foo
#--------------------------------------------------------------------------
	RBC: 
		lw $t0, RBC_count
		addi $t0, $t0, 1 # increasing the 'RBC' test count
		sw $t0, RBC_count
		mov.s $f1, $f18
		l.s $f2, RBC_sum 
		add.s $f2, $f2, $f1 # Adding the current test result with the 'RBC_sum' from previpus lines
		s.s $f2, RBC_sum
		la $a1, line_buffer     # Load line buffer address
		li $t9, 0
	j    read_file_loop_foo
#--------------------------------------------------------------------------
	LDL:
		lw $t0, LDL_count
		addi $t0, $t0, 1 # increasing the 'LDL' test count
		sw $t0, LDL_count
		mov.s $f1, $f18
		l.s $f2, LDL_sum 
		add.s $f2, $f2, $f1 # Adding the current test result with the 'LDL_sum' from previpus lines
		s.s $f2, LDL_sum
		la $a1, line_buffer   # Load line buffer address
		li $t9, 0
	j    read_file_loop_foo
#--------------------------------------------------------------------------
	BPT:
		lw $t0, BPT_count
		addi $t0, $t0, 1  # increasing the 'BPT' test count
		sw $t0, BPT_count
		mov.s $f15, $f18
		mov.s $f2, $f6
		mov.s $f3, $f7
		move $t4, $t6 #t4 contains fractional part of second result 
		jal countDigits_method # A method to count digits after '.' in the second test result 
		jal complete_converting  # A method to return the final second test result converted to floating point number 
		
		mov.s $f19, $f18
		mov.s $f18, $f15
		mov.s $f1, $f18
		l.s $f2, BPT_sum1 
		add.s $f2, $f2, $f1 # Adding the current test result with the 'BPT_sum1' from previpus lines (first result)
		s.s $f2, BPT_sum1
		mov.s $f1, $f19
		l.s $f2, BPT_sum2 
	
		add.s $f2, $f2, $f1  # Adding the current test result with the 'BPT_sum2' from previpus lines (second result) 
		s.s $f2, BPT_sum2
		l.s $f2, BPT_sum2 
		la $a1, line_buffer     # Load line buffer address
		li $t9, 0
	j    read_file_loop_foo
	
	end_of_file_foo: 
		# Close the file
		li $v0, 16                # Close syscall code
		move $a0, $s0             # File descriptor
		syscall
		
	#Hgb: 
		lw $a0, Hgb_count
		jal converttoFloat # Converting the 'Hgb_count' to floating point number 
		mov.s $f14, $f0
		l.s $f2, Hgb_sum 
		la $a0, Hgb_average 
	jal compute_average # Computing the average value according to sum and count 
	
	#BGT: 
		lw $a0, BGT_count 
		jal converttoFloat # Converting the 'BGT_count' to floating point number 
		mov.s $f14, $f0
		l.s $f2, BGT_sum 
		la $a0, BGT_average
	jal compute_average # Computing the average value according to sum and count 
	
	#LDL:
		lw $a0, LDL_count
		jal converttoFloat # Converting the 'LDL_count' to floating point number 
		mov.s $f14, $f0
		l.s $f2, LDL_sum 
		la $a0, LDL_average
	jal compute_average # Computing the average value according to sum and count 
	
	#RBC
		lw $a0, RBC_count
		jal converttoFloat # Converting the 'RBC_count' to floating point number 
		mov.s $f14, $f0
		l.s $f2, RBC_sum 
		la $a0, RBC_average
	jal compute_average # Computing the average value according to sum and count 
	
	#Bpt
		lw $a0, BPT_count
		jal converttoFloat # Converting the 'BPT_count' to floating point number 
		mov.s $f14, $f0
		l.s $f2, BPT_sum1 
		la $a0, BPT_Systolic_average
		jal compute_average # Computing the average value of BPT Systolic according to sum and count 
		
		l.s $f2, BPT_sum2 
		la $a0, BPT_Diastolic_average
		jal compute_average # Computing the average value of BPT Diastolic according to sum and count 
	j back
#---------------------------------------------------------Fifth Function----------------------------------------------------------------
	fifth_operation:
		la $a0, lines
		jal clear_buffer
		la $a0, fileSpace 
		jal clear_buffer # Clearing the buffer which holds the file lines before editing to hold changes in each time 
		la $a0, modified_file
		jal clear_buffer # Clearing the buffer which holds the file lines after updating to hold changes in each time 
		la $a0, fileName
		li $a1, 0 #file flag = read (0) (read=0, write=1)
		jal open_file

		la $a1, fileSpace #read the file and store its characters in 'fileSpace'
	reading_3: 
		jal read_file_character
		beqz $v0, endofFile_3
		lb $t3, 0($a1)
		addi $a1, $a1, 1
	j reading_3
	
	endofFile_3:
		jal closing_file 
		la $a0, fileSpace 
	jal print_file

		la $a0, update_line # Prompt the user to choose a line to update 
		li $v0, 4
		syscall
		li $v0, 5 # Waiting the user to enter an input 
		syscall 
		move $t0, $v0 #t0=number of line to delete
		
	# Open the original file for reading
		la $a0, fileName            # file name
		li $a1, 0                   # read-only mode
		jal open_file

		li $t2, 1                   # Line counter
		li $t9, 0
		li $t7,0 # Index of the character in 'lines' buffer 
		la $a1, line_buffer # A buffer to hold the characters of the lines ehich will remain in the file 
		
	read_loopp: 
		jal read_file_character
		beqz $v0, end_close_filee # Check for end of file
		lb $t3, ($a1) 
		sb $t3, lines($t7)
		addi $t7, $t7, 1
		bne $t2, $t0, storeModifiedd  # If the current line is not the line which will be updated, the current character will remain in the file
	j check_new_linee
	
	storeModifiedd: 
		lb $t3, line_buffer
		sb $t3, modified_file($t9)
		addi $t9, $t9,1  
		
	check_new_linee: # Check for newline character
		lb $t3, line_buffer
		beq $t3, '\n' , endofLinee
	j read_loopp
	
	endofLinee: # A new line reached so the line counter must increase and the index of 'lines' must returns to zero
		sb $zero, lines($t7)
		beq $t2, $t0, askForNew # If the current line is the line to be updated, ask the user for new data
		li $t7, 0
		addi $t2, $t2, 1
	j read_loopp
	
	askForNew: 
		la $a0, prompt_newResult # Prompt the user to enter the new test result 
		jal print_string
		
	# Read user input
		li $v0, 8         # syscall code for reading string
		la $a0, userNewinput     # load address of input buffer
		li $a1, 50       # maximum length of input
		syscall           # read user input
		# concatenate old line with new test result 
		
		la $a0, lines 
		
	concat: # Concatenate the line without the old test result with the new test result entered by the user 
		la $a0, lines
		jal extractName
		addi $s2, $s2, 11 # s2 points to first space before test result 
		sb $zero, ($s2) 
		
		#now concat. user input with line 
		la $a0, lines
		la $a1, userNewinput
		jal concat_strings 
		la $a0, final_buffer
		
	store_modified: # Adding the new line to the 'modified_file' buffer 
		lb $t3, ($a0)
		beqz $t3, line_ended
		sb $t3, modified_file($t9)
		addi $t9, $t9,1  
		addi $a0, $a0, 1
	j store_modified 
	
	line_ended: 
		li $t7, 0  # Preparing for reading the next line by clearing the 'lines' buffer index and clearing the buffer itself 
		la $a0, lines
		jal clear_buffer
		addi $t2, $t2, 1 # Increasing the line counter 
		la $a1, line_buffer
	j read_loopp
	
	end_close_filee: 
		jal closing_file
		sb $zero, modified_file($t9)
		la $a0, modified_file
		jal count_chars # Counting the characters to be added to the file 
		
	# Open the original file for writing (to truncate it)
		la $a0, fileName            # file name
		li $a1, 1                   # write-only mode
		jal open_file
		move $s1, $s0               # store file descriptor for writing

		li $v0, 15 # System call to write data to a file
		move $a0, $s1 #file descriptor
		la $a1, modified_file
		move $a2, $t8   # Move length of data to be written in file into $a2 (data length)
		syscall 
		move $s0, $s1
		jal closing_file 
	j back
#---------------------------------------------------------Sixth Function----------------------------------------------------------------
	sixth_operation:
		la $a0, lines
		jal clear_buffer 
		la $a0, fileSpace
		jal clear_buffer # Clearing the buffer which holds the file lines before deleting to hold changes in each time 
		la $a0, modified_file
		jal clear_buffer # Clearing the buffer which holds the file lines after deleting to hold changes in each time 
		la $a0, fileName
		li $a1, 0 #file flag = read (0) (read=0, write=1)
		jal open_file
		
		la $a1, fileSpace #read the file and store its characters in 'fileSpace'
	reading_2: 
		jal read_file_character
		beqz $v0, endofFile_2
		lb $t3, 0($a1)
		addi $a1, $a1, 1
	j reading_2
	
	endofFile_2:
		jal closing_file 
		la $a0, fileSpace 
	jal print_file

		la $a0, delete_line # Prompt the user to choose a line to delete 
		li $v0, 4
		syscall

		li $v0, 5 # Waiting the user to enter an input 
		syscall 
		move $t0, $v0 #t0=number of line to delete

	# Open the original file for reading
		la $a0, fileName            # file name
		li $a1, 0                   # read-only mode
		jal open_file
		li $t2, 1                   # Line counter
		li $t9, 0
		la $a1, line_buffer
		
	read_loop: 
		jal read_file_character
		beqz $v0, end_close_file 		# Check for end of file
		bne $t2, $t0, storeModified
	j check_new_line
		storeModified: 
		lb $t3, line_buffer
		sb $t3, modified_file($t9)
		addi $t9, $t9,1
		
	check_new_line: # Check for newline character
		lb $t3, line_buffer
		beq $t3, '\n' , endofLine
	j read_loop
	
	endofLine:
		addi $t2, $t2, 1
	j read_loop
	
	end_close_file: 
		jal closing_file
		sb $zero, modified_file($t9)
		la $a0, modified_file
		jal count_chars
		
	# Open the original file for writing (to truncate it)
		la $a0, fileName            # file name
		li $a1, 1                   # write-only mode
		jal open_file
		move $s1, $s0               # store file descriptor for writing

		li $v0, 15
		move $a0, $s1
		la $a1, modified_file
		move $a2, $t8
		syscall 

		move $s0, $s1
		jal closing_file 
	j back
#---------------------------------------------------------Methods----------------------------------------------------------------
# Custom subroutine to convert a string to an integer 
	str2int:
		li $v0, 0                    # initialize v0 to 0 
		li $t0, 10
	first_Loop: 
		lb $t1, 0($a0)
		beqz $t1, end_convert1   # Check for null terminator
		blt $t1, '0', done2 # Check if the character in $t1 is less than the ASCII value of '0'
		bgt $t1, '9', done2 # Check if the character in $t1 is greater than the ASCII value of '9'
		addiu $t1, $t1, -48  # Convert ASCII character to its numerical value
		mul $v0, $v0, $t0
		addu $v0, $v0, $t1
		addiu $a0, $a0, 1  # Move to the next character in the string
	j first_Loop
	done2:
		addiu $a0, $a0, 1  # Move to the next character in the string if the previous character not a digit 
	j first_Loop
	end_convert1: 
	jr $ra
# Custom subroutine to  read a file character by character 
	read_file_character:
		li $v0, 14                # Read syscall code
		move $a0, $s0             # File descriptor
		li $a2, 1               # Maximum number of characters to read
		syscall
	jr $ra
# Custom subroutine to extract test name from a line in the file 
	extractName:
		li $s2, ':'
	find_startof_name:
		lb $s3, 0($a0)
		beq $s3, $s2, startof_name # If the current character is ':' so we reached the end of the ID 
		addi $a0, $a0, 1 # Move to the next character 
	j find_startof_name
	startof_name:
		addi $a0, $a0, 1 #$a0 points to the space before the first character of the test name
		move $s2, $a0
		li $s7, ','
		la $s6, extracted_chars
	store_name:
		lb $s3, 0($s2)
		move $s1, $s2 #s1 points to first ',' after test name
		beq $s3, $s7, endof_name # If ',' is reached so the test name ended 
		sb $s3, 0($s6) # Storing the current character in 'extracted_chars' 
		addi $s2, $s2, 1
		addi $s6, $s6, 1
	j store_name
	endof_name: 
		sb $zero, 0($s6) 
	jr $ra
# Custom subroutine to compare two strings
	beq_string:
		li $v0, 0
		lb $t4, ($a0)
		lb $t5, ($a1)
		beq $t4, $t5, continue
	jr $ra
	continue:
		beqz $t4, equal
		addi $a0, $a0, 1
		addi $a1, $a1, 1
	j beq_string
	equal:
		li $v0, 1
	jr $ra
# Custom subroutine to extract test resukt from a line in the file
	extract_testResult:
		li $t0, 0
		# clearing previous results 
		sw $t0, integer_value
		sw $t0, integer_part
		sw $t0, fractional_value
		sw $t0, fractional_part
		l.s $f0, zero_float
		mov.s $f18, $f0
		li $s2, ','
	find_startof_result:
		lb $s3, 0($a0)
		beq $s3, $s2, startof_result # Test result is reached 
		addi $a0, $a0, 1
	j find_startof_result	
	startof_result:
		addi $a0, $a0, 11 #$a0 points to the first digit of the test result
		move $s2, $a0
		li $s7, '.' # Points to the end of the integer part 
		li $s5, ','
		la $s6, integer_value
		la $t6, fractional_value
	store_result:
		lb $s3, 0($s2)
		beq $s3, $s7, endof_integerPart
		beqz $s3, endofResult
		beq $s3, $s5, read_nextResult # Only in case of 'BPT' tests 
		sb $s3, 0($s6)
		addi $s2, $s2, 1
		addi $s6, $s6, 1
		addi $t9, $t9, 1
	j store_result
	endof_integerPart:
		sb $zero, 0($s6)
		addi $s2, $s2, 1 
		move $s6, $t6 # Moving to fractional part 
		li $t9, 0
	j store_result
	read_nextResult: # Reading next result in case of 'BPT' 
		la $s6, integer_part
		la $t6, fractional_part
		addi $s2, $s2, 2
	j store_result
	endofResult:
		sb $zero, 0($s6)
	jr $ra
# Custom subroutine to convert an integer to a floating point number 
	converttoFloat:
		li $t0, 0           # Load zero into $t0
		mtc1 $t0, $f0      # Clear $f0 
		cvt.s.w $f0, $f0
		mtc1 $a0, $f0    # Move the value in $a0 to $f0 (integer to floating-point conversion)
		cvt.s.w $f0, $f0 # Convert the integer value in $f0 to a single-precision floating-point value
	jr $ra
# Custom subroutine to completely convert integer and fractional parts into one floating point value 
	complete_converting:
		l.s $f4, fraction_constant
		l.s $f5, zero_float
	Divide_toZero: # Deviding fractional part by 10 according to number of digits after '.' in the original number
		mul.s $f3, $f3, $f4
		c.eq.s $f3, $f5		# Compare $f0 with zero
		bc1t addition		# Branch if $f0 is equal to zero
		subi $a1, $a1, 1	# Subtracting the number of digits stored in $a1 by 1 
		bne $a1, 0, Divide_toZero
	addition: # Adding integer part with fractional part 
		add.s $f2, $f2, $f3
		mov.s $f18, $f2 # Storing the final floating point number in $f18 
	jr $ra
# Custom subroutine to open a file and test with checking the success of the process
	open_file: 
		li $v0, 13 #open file, syscall=13
		syscall 
		bgez $v0, open_success   # branch if file opened successfully
	j skip 
	open_success:
		move $s0, $v0       # save the file descriptor $s0=file
		li $v0, 4
		la $a0, Success
		syscall
	jr $ra
	skip: # The process failed 
		li $v0, 4
		la $a0, Error
		syscall
	j end_Program
# Custom subroutine to print the lines of a file 
	print_file: 
		move $t1, $a0 # Saving the current value of a0 to use later 
		li $t4, 1 # t4 hold the line number 
		move $a0, $t4
		li $v0, 1
		syscall # Print the line number 
		li $v0, 11             # Print character syscall code
		li $a0, '-'            # Space character
		syscall                # Print space
		move $a0, $t1 # Returning a0 to its previous valuee 
	print_buffer: 
		lb $t0, ($a0) 
		move $t1, $a0 # Saving the current value of a0 to use it later 
		beqz $t0, end_print # Checking the end of file 
		beq $t0, '\n', add_and_print 
		li $v0, 11 #Printing the current character
		move $a0, $t0
		syscall 
	return: # Move to next character in the file 
		move $a0, $t1
		addi $a0, $a0, 1
	j print_buffer
	add_and_print:
		move $t1, $a0
		li $v0, 11
		move $a0, $t0
		syscall 
		addi $t4, $t4, 1 # Increase the line number 
		move $a0, $t4
		li $v0, 1
		syscall
		li $v0, 11             # Print character syscall code
		li $a0, '-'            # Space character
		syscall                # Print space
		j return
	end_print: 
		la $a0, lines_of_file
		sw $t4, ($a0)
	jr $ra
# Custom subroutine to print a string 
	print_string:
		li $v0, 4
		syscall
	jr $ra
# Custom subroutine to extract the ID from a line in the file 
	extract_ID: 
		li $t2, ':'
		extract_loop:
		lb $t3, 0($a0)   
		beq $t3, $t2, end_extract         # Exit loop if ':' is encountered
		sb $t3, 0($a1)                # Store the character in the output buffer
		addi $a0, $a0, 1              # Move to the next character in the buffer
		addi $a1, $a1, 1              # Move to the next position in the output buffer
	j extract_loop                    # Repeat loop
	end_extract: 	
		sb $zero, 0($a1)              # Null-terminate the output buffer
	jr $ra
# Custom subroutine to compare two strings
	start_of_second_operation:
		li $v0, 4                 # Print string syscall code
		la $a0, promptID      # Load prompt string
		syscall
		li $v0, 8                 # Read string syscall code
		la $a0, input_buffer_ID      # Load input buffer address
		li $a1, 8                # Maximum number of characters to read
		syscall	
		move $s1, $a0             # Save the address of the input buffer
	jr $ra
# Custom subroutine to clear specific buffers 
	clear_results:
		li $t0, 0
		sw $t0, integer_value
		sw $t0, fractional_value
		sw $t0, integer_part
		sw $t0, fractional_part
		sw $t0, Hgb_count 
		sw $t0, BGT_count 
		sw $t0, LDL_count 
		sw $t0, RBC_count 
		sw $t0, BPT_count 
		sw $t0, Hgb_sum
		sw $t0, BGT_sum  
		sw $t0, LDL_sum 
		sw $t0, RBC_sum 
		sw $t0, BPT_sum1
		sw $t0, BPT_sum2
		l.s $f0, zero_float
		mov.s $f18, $f0
		mov.s $f19, $f0
		mov.s $f2 $f0
		mov.s $f3, $f0
		mov.s $f6, $f0
		mov.s $f7, $f0
		mov.s $f12, $f0
		mov.s $f15, $f0
	jr $ra 
# Custom subroutine to set ' flag_foundID' flag 
	set_flag:
		li $t0, 1
		la $t1,  flag_foundID
		sw $t0, 0($t1) 
	jr $ra
# Custom subroutine to count digits of an integer 
	countDigits_method: 
		li $a1, 0
		counts:
		beqz $t4, countDone_
		div $t4, $t4, 10
		addi $a1, $a1, 1
	j counts
	countDone_: 
	jr $ra
# Custom subroutine to check upnormal test results 
	check_upnormal: 
		mov.s $f3, $f18 # Storing test result in $f3 
	checking_loop:
		c.lt.s $f3, $f12   # Compare if $f3 is less than $f12 
		bc1t not_upnormal # Maximum value is less than the current test result so it is not upnormal 
		li $t0, 1 # If the result is upnormal, print it and set the flag 
		sw $t0, foundTests
		move $t0, $a0
		li $v0, 4
		la $a0, line_break
		syscall
		move $a0, $t0
		syscall
	jr $ra
	not_upnormal:
		la $t0, is_BPT # Checking if the current test is 'BPT' so check for the second result 
		lw $t1, 0($t0)
		beq $t1, 1 , checkresult2
	jr $ra
	checkresult2: 
		mov.s $f3, $f19
		l.s $f12, BPT_Diastolic_max
		la $t0, is_BPT 
		sw $zero, 0($t0)
	j checking_loop
# Custom subroutine to read a string from the user 
	read_string: 
		li $v0, 8
		syscall
	jr $ra
# Custom subroutine to check if a test result is unnormal (out of normal range) 
	check_unnormal: 
		mov.s $f3, $f18
		c.lt.s $f3, $f12   # if the test result < maximum value , check it it is < he minimum value 
		bc1t second_check
		li $t0, 1 # If the test result is > maximum value so it is unnormal, set the flag and print the line 
		sw $t0, foundTests
		move $t0, $a0
		li $v0, 4
		la $a0, line_break
		syscall
		move $a0, $t0
		syscall
	jr $ra
	second_check: # If the test result is less than the minimum value 
		c.lt.s $f3, $f15   # Compare if $f3 is less than $f12 so print the line
		bc1t unNormal
		jr $ra
	unNormal: # If the test result is unnormal, set the flag and print the line 
		move $t0, $a0
		li $v0, 4
		la $a0, line_break
		syscall
		move $a0, $t0
		syscall
		li $t0, 1
		sw $t0, foundTests
	jr $ra
# Custom subroutine to compute average value of a test, given the sum and the count 	
	compute_average: 
		li $v0, 4
		syscall
		div.s $f12, $f2, $f14
		li $v0, 2
		syscall
	jr $ra
# Custom subroutine to remove '-' from a string 
	convert_without_dash: 
		li $t1, '-'
	store_without_dash: 	
		lb $t3, ($a0)
		beq $t3, $t1, skip_dash
		beqz $t3, ready_date_without_dash
		sb $t3, ($a1)
		addi $a0, $a0, 1
		addi $a1, $a1, 1
	j store_without_dash
	skip_dash: 
		addi $a0, $a0, 1
	j  store_without_dash  
	ready_date_without_dash: 
		sb $zero, ($a1)
	jr $ra  
# Custom subroutine to count characters of a string 
	count_chars: 
		li $t8, 0
	check_tillEnd:
		lb $t3, ($a0)
		beqz $t3, finish_checking
		addi $t8, $t8, 1
		addi $a0, $a0, 1
	j check_tillEnd
	finish_checking:
	jr $ra
# Custom subroutine to clear a specific buffer 
	clear_buffer:
		move $t0, $a0
	clear_loop:
		lb $t1, 0($t0)
		beqz $t1, end_clear  # If it's null, exit the loop
		sb $zero, 0($t0)
		addi $t0, $t0, 1
	j clear_loop
	end_clear:
	jr $ra
# Custom subroutine to close a file 
	closing_file:
		li $v0, 16                # System call code for close file
		move $a0, $s0             # File handle
		syscall                   # Close the file
	jr $ra
# Custom subroutine to concatenate two strings 
	concat_strings:
		move $t0, $a0           # $t0 = address of the first buffer
		move $t1, $a1           # $t1 = address of the second buffer
		la $a0, final_buffer    # $a0 = address of the destination buffer
		li $t6, 0               # Initialize loop counter
	string1:
		lb $t3, ($t0)           # Load character from the first buffer
		beqz $t3, string2  # If null terminator is encountered, jump to append_next
		sb $t3, ($a0)           # Store character in the destination buffer
		addi $a0, $a0, 1        # Move to the next position in the destination buffer
		addi $t0, $t0, 1        # Move to the next character in the first buffer
	j string1    # Repeat until null terminator is encountered
	string2:
		lb $t4, ($t1)           # Load character from the second buffer
		beqz $t4, finish_concat # If null terminator is encountered, finish concatenation
		sb $t4, ($a0)           # Store character in the destination buffer
		addi $a0, $a0, 1        # Move to the next position in the destination buffer
		addi $t1, $t1, 1        # Move to the next character in the second buffer
	j string2           # Repeat until null terminator is encountered
	finish_concat:
		sb $zero, ($a0)         # Null-terminate the destination buffer
	jr $ra                  # Return from the function
# Custom subroutine to check if a buffer contains any letters 
	check_only_digits: 
		li $t0, 1
		li $t5, 0
	check_loop:
		lb $t1, 0($a0)     # Load the current character into $t1
		beqz $t1, end_check_only_alphabetic  # If the character is null (end of string), exit loop
		li $t2, 'A'        # ASCII value of 'A'
		blt $t1, $t2, not_alphabetic  # If the character is less than 'A', it's not alphabetic
		li $t2, 'Z'        # ASCII value of 'Z'
		bgt $t1, $t2, lowercase_check  # If the character is greater than 'Z', check if it's lowercase
	j found_alphabetic
	lowercase_check:
		li $t2, 'a'        # ASCII value of 'a'
		blt $t1, $t2, not_alphabetic  # If the character is less than 'a', it's not alphabetic
		li $t2, 'z'        # ASCII value of 'z'
		bgt $t1, $t2, not_alphabetic  # If the character is greater than 'z', it's not alphabetic  
	found_alphabetic:
		li $t0, 0          # Set $t0 to 1 to indicate the string contains alphabetic characters
	j end_check_only_alphabetic
	not_alphabetic:
		beq $t2, '.', float 
	j con
	float: 
		li $t5, 1
	con: 
		addi $a0, $a0, 1
	j check_loop
	end_check_only_alphabetic:
	jr $ra             # Return to the calling function
# Custom subroutine to extract the date from a line 
	extractDate: 
		li $t1, ','             
	find__startof_date:
		lb $t3, 0($t0)      
		beq $t3, $t1, found_startof_date 
		addi $t0, $t0, 1    
	j find__startof_date
	found_startof_date:
		addi $t0, $t0, 1  
		la $s6,  date_buffer 
	store_date: 
		lb $s7, 0($t0)
		beq $s7, ',', date_ready
		sb  $s7, ($s6)
		addi $s6, $s6, 1
		addi $t0, $t0, 1  
	j store_date 
	date_ready:
		sb $zero, 0($s6) 
	jr $ra
# Custom subroutine to extract the month from a date buffer 
	extractMonth: 
		la $t4, extracted_month
		li $t5, '-'
		la $t6, extracted_month 
		searchingForMonth: 
		lb $t3, ($a0)
		beq $t3, $t5, startOfMonth
		addi $a0, $a0, 1
	j searchingForMonth
	startOfMonth: 
		addi $a0, $a0, 1
	storeMonth: 
		lb $t3, ($a0) 
		beqz $t3, readyMonth
		sb $t3, ($t6)
		addi $a0, $a0, 1
		addi $t6, $t6, 1
	j storeMonth
	readyMonth: 
		sb $zero, ($t6) 
	jr $ra
	end_Program:
		li $v0, 10   # syscall code for program termination
		syscall      # End the program
