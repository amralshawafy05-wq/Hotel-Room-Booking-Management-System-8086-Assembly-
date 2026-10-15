                          ORG 100H

JMP MAIN

ROOMS DB 0,0,0,0,0    
 

MENU DB 13,10,'1- Book 2- Cancel 3- Status 4- Exit: $'
MSG_ROOM DB 13,10,'Enter Room No (0-4): $'
MSG_BOOKED DB 13,10,'Success! Room Booked.$'
MSG_ALREADY DB 13,10,'Room Already Booked!$'
MSG_CANCEL DB 13,10,'Booking Canceled.$'
MSG_STATUS DB 13,10,'Room Status (0=Free, 1=Full): $'
MSG_INVALID DB 13,10,'Invalid Room Number!$'
MSG_MENU_INVALID DB 13,10,'Please choose from 1-4!$'


MAIN:

    MOV AX,CS
    MOV DS,AX


MENU_LOOP:

    LEA DX,MENU
    MOV AH,09H
    INT 21H

    MOV AH,01H
    INT 21H
    SUB AL,'0'

    CMP AL,1
    JE BOOK_ROOM

    CMP AL,2
    JE CANCEL_ROOM

    CMP AL,3
    JE STATUS_ROOM

    CMP AL,4
    JE EXIT_PROG

    ; If the user enters a number other than 1-4
    LEA DX,MSG_MENU_INVALID
    MOV AH,09H
    INT 21H

    JMP MENU_LOOP


BOOK_ROOM:

    CALL GET_INDEX

    JC MENU_LOOP

    MOV SI,AX

    CMP ROOMS[SI],1
    JE ALREADY_BOOKED

    MOV ROOMS[SI],1

    LEA DX,MSG_BOOKED
    MOV AH,09H
    INT 21H

    JMP MENU_LOOP


ALREADY_BOOKED:

    LEA DX,MSG_ALREADY
    MOV AH,09H
    INT 21H

    JMP MENU_LOOP


CANCEL_ROOM:

    CALL GET_INDEX

    JC MENU_LOOP

    MOV SI,AX

    MOV ROOMS[SI],0

    LEA DX,MSG_CANCEL
    MOV AH,09H
    INT 21H

    JMP MENU_LOOP


STATUS_ROOM:

    CALL GET_INDEX

    JC MENU_LOOP

    MOV SI,AX

    MOV BL,ROOMS[SI]

    ADD BL,'0'

    LEA DX,MSG_STATUS
    MOV AH,09H
    INT 21H

    MOV DL,BL
    MOV AH,02H
    INT 21H

    JMP MENU_LOOP


GET_INDEX:

    LEA DX,MSG_ROOM
    MOV AH,09H
    INT 21H

    MOV AH,01H
    INT 21H

    SUB AL,'0'

    CMP AL,0
    JB INVALID_ROOM

    CMP AL,4
    JA INVALID_ROOM

    MOV AH,0

    CLC
    RET


INVALID_ROOM:

    LEA DX,MSG_INVALID
    MOV AH,09H
    INT 21H

    STC
    RET


EXIT_PROG:

    MOV AH,4CH
    INT 21H

END MAIN