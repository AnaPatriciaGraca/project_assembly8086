org 100h
WindowColor macro x1,y1,x2,y2,color  
mov ax, 0600h      ;screen config
mov cl, x1
mov ch, y1
mov dl, x2
mov dh, y2
mov bh, color
int 10h
endm
main proc
    mov al, 1
    mov ah, 05h
    int 10h
    
    WindowColor 0,0,80,25,07ch      ;01 for blue color  
endp
ret





.stack 100h
.data

Jan   db  "         January           ",13,10 
      db  "Sun Mon Tue Wed Thu Fri Sat",13,10 
      db  "                 1   2   3 ",13,10 
      db  " 4   5   6   7   8   9  10 ",13,10 
      db  "11  12  13  14  15  16  17 ",13,10 
      db  "18  19  20  21  22  23  24 ",13,10 
      db  "25  26  27  28  29  30  31 "       
; text-background * 16 + text-color
;Black         =  0
;Blue          =  1
;Green         =  2
;Cyan          =  3
;Red           =  4
;Magenta       =  5
;Brown         =  6
;LightGray     =  7
;DarkGray      =  8
;LightBlue     =  9
;LightGreen    = 10
;LightCyan     = 11
;LightRed      = 12
;LightMagenta  = 13
;Yellow        = 14
;White         = 15
color db 113

.code          
;INITIALIZE DATA SEGMENT.
  mov  ax,@data
  mov  ds,ax 

;DISPLAY STRING WITH COLOR.
  mov  es,ax ;ES SEGMENT MUST POINT TO DATA SEGMENT.
  mov  ah,13h ;SERVICE TO DISPLAY STRING WITH COLOR.
  mov  bp,offset Jan ;STRING TO DISPLAY.
  mov  bh,0 ;PAGE (ALWAYS ZERO).
  mov  bl,color
  mov  cx,201 ;STRING LENGTH.
  mov  dl,0 ;X (SCREEN COORDINATE). 
  mov  dh,0 ;Y (SCREEN COORDINATE). 
  int  10h ;BIOS SCREEN SERVICES.  

;FINISH THE PROGRAM PROPERLY.
  mov  ax,4c00h
  int  21h