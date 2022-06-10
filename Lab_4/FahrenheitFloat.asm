#Lab 4 - Part 2a

.data
value: .asciz "Enter a temperature value: "
valueCelcius: .asciz "The temperature in Celsius is: "
valueKelvin: .asciz "The temperature in Kelvin is: "
newLn: .asciz "\r\n"
 
Fahrenheit: .float 0 
Celcius: .float 0 
Kelvin: .float 0 
kelvinConversionValue: .float 273.15

.text
main: 	flw fa0, Fahrenheit, t0 
      	flw fa1, Celcius, t0 
	flw fa2, Kelvin, t0 

	flw ft3, kelvinConversionValue, t0 
	li a7, 4 
	la a0,value
	ecall 
	li a7, 6
	ecall 
	
	jal valueConv_C
	jal valueConv_K

#------------------------------------------------------------
# Conversions for entered values
valueConv_C: li t0,5
	     li t1, 9 
	     li t2, 32
	     
	fcvt.s.w ft0, t0
	fcvt.s.w ft1, t1
	fcvt.s.w ft2, t2 
	fsub.s fs2, fa0 , ft2 
	fdiv.s fs3, ft0, ft1 
	fmul.s fa1, fs2, fs3 
	
	li a7, 4
	la a0, valueCelcius
	ecall 
	li a7, 2 
	fmv.s fa0, fa1 
	ecall 
	ret 

valueConv_K: flw ft3, kelvinConversionValue, t0
	     fadd.s fa0, fa0, ft3 
	
	li a7, 4 
	la a0, newLn 
	ecall 
	li a7, 4 
	la a0, valueKelvin
	ecall 

	li a7, 2 
	ecall 
