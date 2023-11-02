REM ClawMachine - claw stepper motor
REM MachiKania type P (Raspberry Pi Pico)

N=0
WHILE 1
	B=IN(12)
	C=IN(13)
	D=IN(9)

	IF B=0 AND D=0 THEN
		REM open
		GOSUB(dir,0)
		GOSUB(enable,0)
		GOSUB(gostep)
		OUT 0,0
	ELSEIF C=0 AND N>0 THEN
		REM close
		GOSUB(dir,1)
		GOSUB(enable,0)
		GOSUB(gostep)
		OUT 0,0
		N=N-1
	ELSE
		REM stop
		GOSUB(enable,1)
		OUT 0,1
	ENDIF

	REM limit
	IF D=1 THEN N=1000
WEND

LABEL enable
	VAR A
	A=ARGS(1)
	OUT 8,A
RETURN

LABEL dir
	VAR A
	A=ARGS(1)
	OUT 1,A
RETURN

LABEL gostep
	OUT 2,1
	DELAYMS 1
	OUT 2,0
	DELAYMS 1
RETURN
