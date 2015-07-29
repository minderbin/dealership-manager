.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\comctl32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib comctl32.lib

USER STRUCT
    ulevel      BYTE 3 ;user level of 3 as default (lowest)
    uname       BYTE 20  dup(0)
    upass       BYTE 20  dup(0)
USER ends

VEHICLE STRUCT
    rego        BYTE 8   dup(0)
    make        BYTE 10  dup(0)
    model       BYTE 15  dup(0)
    salesman    BYTE 20  dup(0) 
VEHICLE ends

DEALER STRUCT
    dname       BYTE 20  dup(0)
    dmanager    BYTE 20  dup(0)
    daddress    BYTE 30  dup(0)
DEALER ends

szText MACRO Name, Text:VARARG
LOCAL lbl
  jmp lbl
    Name db Text,0
  lbl:
ENDM

WinMain                        proto :DWORD,:DWORD,:DWORD,:DWORD
WinLogin                       proto :DWORD,:DWORD,:DWORD,:DWORD
AddUser                        proto :USER
AddVehicle                     proto :VEHICLE
AddDealer                      proto :DEALER
VerifyDB                       proto
CreateUserDB                   proto
CreateVehicleDB                proto
CreateDealerDB                 proto
FindUser                       proto user:USER
ListBox                        proto :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SpaceFillDisplayVehicle        proto
UpdateVehicleDisplay           proto
ListBoxProc                    proto :DWORD,:DWORD,:DWORD,:DWORD
GetVehicleAtIndex              proto :DWORD
DeleteVehicleProc              proto :DWORD,:DWORD,:DWORD,:DWORD
DeleteVehicle                  proto :DWORD
AddVehicleProc                 proto :DWORD,:DWORD,:DWORD,:DWORD
ClearVehicle                   proto :DWORD
UpdateVehicleProc              proto :DWORD,:DWORD,:DWORD,:DWORD
ClearVehicleProc               proto :DWORD,:DWORD,:DWORD,:DWORD
GetUserAtIndex                 proto :DWORD
UpdateUserDisplay              proto
SpaceFillDisplayUser           proto
DeleteUserProc                 proto :DWORD,:DWORD,:DWORD,:DWORD
DeleteUser                     proto :DWORD
AddUserProc                    proto :DWORD,:DWORD,:DWORD,:DWORD
ClearUser                      proto :DWORD
UpdateUserProc                 proto :DWORD,:DWORD,:DWORD,:DWORD
ClearUserProc                  proto :DWORD,:DWORD,:DWORD,:DWORD
StaticProc                     proto :DWORD,:DWORD,:DWORD,:DWORD
UpdateDealerDisplay            proto
SpaceFillDisplayDealer         proto
GetDealerAtIndex               proto :DWORD
DeleteDealerProc               proto :DWORD,:DWORD,:DWORD,:DWORD
DeleteDealer                   proto :DWORD
AddDealerProc                  proto :DWORD,:DWORD,:DWORD,:DWORD
ClearDealer                    proto :DWORD
UpdateDealerProc               proto :DWORD,:DWORD,:DWORD,:DWORD
ClearDealerProc                proto :DWORD,:DWORD,:DWORD,:DWORD

.data
ClassName                      db "WinClass",0
ClassNameLogin                 db "WinClassLogin",0
AppName                        db "ElCheapo Management System - "
TitleUserInfo                  db 32 dup(20h),0
   
userdbname                     db 'users.db',0
vehicledbname                  db 'vehicles.db',0
dealerdbname                   db 'dealers.db',0

MenuName                       db "Menu",0
ButtonClassName                db "button",0
EditClassName                  db "edit",0
ComboClassName                 db "COMBOBOX",0
TabClassName                   db "SysTabControl32",0
StaticClassName                db "static",0
staticusernametext             db "Username:",0
staticuserpasstext             db "Password:",0

staticvehicleregotext          db "Rego:",0
staticvehiclemaketext          db "Make:",0
staticvehiclemodeltext         db "Model:",0
staticvehiclesalesmantext      db "Salesman:",0

staticuserleveltext            db "Level:",0

staticdealernametext           db "Name:",0
staticdealermanagertext        db "Manager:",0
staticdealeraddresstext        db "Address:",0

ButtonTextLogin                db "&Login",0
ButtonTextDelete               db "&Delete",0
ButtonTextAdd                  db "&Add",0
ButtonTextUpdate               db "&Update",0
ButtonTextClear                db "&Clear",0

userlevel                      db 0
userleveladmin                 db "- (Admin)",0
userlevelmanager               db "- (Manager)",0
userlevelsales                 db "- (Sales)",0
defuser                        USER <1,"admin","admin">
testuser                       USER <2,"manager","manager">
fileuser                       USER <0,,> ;init'd user struct to fill when reading records from db
bufuser                        USER <0,,> ;init'd user struct to fill and pass to finduser function
displayuserlevel               db 8 dup(20h)
displayuser                    USER <0,' ',' '>
db 0

loginsuccess                   db "Login Successful.",0
loginfail                      db "Login failed, username not found. Try again?",0
loginincorrectpass             db "Login failed, incorrect password for user.",0
toomanyfailures                db "Too many unsuccessful login attempts, exiting.",0
blankstring                    db 0

TabTitle1                      db "Vehicles",0
TabTitle2                      db "Users",0
TabTitle3                      db "Dealerships",0
WhichTabChosen                 DWORD 0

testvehicle                    VEHICLE <"KOS-210","Toyota","Corolla","manager">
testvehicle2                   VEHICLE <"ABC-123","Subaru","WRX","admin">
testvehicle3                   VEHICLE    <"TST-222","Ferrari","F50","admin">
displayvehicle                 VEHICLE <' ',' ',' ',' '>
nulltermchar                   db 0
filevehicle                    VEHICLE <,,,>

displaydealer                  DEALER <' ',' ',' '>
nullchar                       db 0
filedealer                     DEALER <,,>
testdealer                     DEALER <"El Cheapo HQ","David Reid","55 Bison St, Sydney">

vehicledeleted                 db "Vehicle Successfully Deleted.",0
vehicleadded                   db "Vehicle Successfully Created.",0
vehicleupdated                 db "Vehicle Successfully Updated.",0

userdeleted                    db "User Successfully Deleted.",0
useradded                      db "User Successfully Created.",0
userupdated                    db "User Successfully Updated.",0
usercmbmsg                     db "Unable to add/update accounts of this type due to current access privileges.",0

dealerdeleted                  db "Dealer Successfully Deleted.",0
dealeradded                    db "Dealer Successfully Created.",0
dealerupdated                  db "Dealer Successfully Updated.",0

admintext                      db "Admin",0
managertext                    db "Manager",0
salestext                      db "Sales",0

.data?
deflistproc                    dd ?
defbuttonproc                  dd ?
defstaticproc                  dd ?

hInstance                      HINSTANCE ?
CommandLine                    LPSTR ?
hwndMain                       HWND ?
hwndButton                     HWND ?
hwndEdit                       HWND ?
buffer                         db 512 dup(?)
userdbhnd                      dd ?
vehicledbhnd                   dd ?
dealerdbhnd                    dd ?
; ====== login controls
hwndLogin                      HWND ?
hwndButtonLogin                HWND ?
hwndEditLoginUsername          HWND ?
hwndEditLoginUserpass          HWND ?
hwndStaticLoginUsername        HWND ?
hwndStaticLoginUserpass        HWND ?
; ====== vehicle controls
hwndEditVehicleRego            HWND ?
hwndStaticVehicleRego          HWND ?
hwndEditVehicleMake            HWND ?
hwndStaticVehicleMake          HWND ?
hwndEditVehicleModel           HWND ?
hwndStaticVehicleModel         HWND ?
hwndEditVehicleSalesman        HWND ?
hwndStaticVehicleSalesman      HWND ?
hwndButtonVehicleDelete        HWND ?
hwndButtonVehicleAdd           HWND ?
hwndButtonVehicleUpdate        HWND ?
hwndButtonVehicleClear         HWND ?
;====== user controls
hwndComboUserLevel             HWND ?
hwndEditUserName               HWND ?
hwndEditUserPass               HWND ?
hwndButtonUserDelete           HWND ?
hwndButtonUserAdd              HWND ?
hwndButtonUserUpdate           HWND ?
hwndButtonUserClear            HWND ?
;====== dealer controls
hwndEditDealerName             HWND ?
hwndEditDealerManager          HWND ?
hwndEditDealerAddress          HWND ?
hwndButtonDealerDelete         HWND ?
hwndButtonDealerAdd            HWND ?
hwndButtonDealerUpdate         HWND ?
hwndButtonDealerClear          HWND ?

hwndTabControl                 HWND ?
ItemStruct                     TC_ITEM <?>    ; Structure used by the Tab Control
Handles                        LABEL DWORD ;---- label for tab handles
hndTab1                        DWORD ?
hndTab2                        DWORD ?
hndTab3                        DWORD ?

;tab list controls
hndVehicleList                 DWORD ?
hndUserList                    DWORD ?
hndDealerList                  DWORD ?

totalloginfailures             BYTE ?
.const
ButtonID                       equ 1
EditID                         equ 2
TabMainID                      equ 8
IDM_HELLO                      equ 1
IDM_CLEAR                      equ 2
IDM_GETTEXT                    equ 3
IDM_EXIT                       equ 4

editidusername                 equ 3
editiduserpass                 equ 4
buttonidlogin                  equ 5
staticidusername               equ 6
staticiduserpass               equ 7

editidvehiclerego              equ 5
staticidvehiclerego            equ 6
editidvehiclemake              equ 7
staticidvehiclemake            equ 8
editidvehiclemodel             equ 9
staticidvehiclemodel           equ 10
editidvehiclesalesman          equ 11
staticidvehiclesalesman        equ 12
buttonidvehicledelete          equ 14
buttonidvehicleadd             equ 15
buttonidvehicleupdate          equ 16
buttonidvehicleclear           equ 17

comboiduserlevel               equ 5

USERLEVEL_ADMIN                equ 1
USERLEVEL_MANAGER              equ 2
USERLEVEL_SALES                equ 3

.code
start:
    invoke GetModuleHandle, NULL
    mov    hInstance,eax
    invoke GetCommandLine
    invoke WinLogin, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
    .IF userlevel > 0
        invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
    .ENDIF
    invoke ExitProcess,eax

;===============================================
;    WinMain(HINSTANCE hInst,HINSTANCE hPrevInst,LPSTR CmdLine,dword CmdShow)
;    Window creation function for the main
;    window. Window class is created and filled,
;    window is created then centred to screen
;    dimensions (works accross different 
;    resolutions). Message handler is created.
;===============================================
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
    LOCAL wc:WNDCLASSEX
    LOCAL msg:MSG
    mov   wc.cbSize,SIZEOF WNDCLASSEX
    mov   wc.style, CS_HREDRAW or CS_VREDRAW
    mov   wc.lpfnWndProc, OFFSET WndProc
    mov   wc.cbClsExtra,NULL
    mov   wc.cbWndExtra,NULL
    push  hInst
    pop   wc.hInstance
    mov   wc.hbrBackground,COLOR_BTNFACE+1
    mov   wc.lpszMenuName,OFFSET MenuName
    mov   wc.lpszClassName,OFFSET ClassName
    invoke LoadIcon,NULL,IDI_APPLICATION
    mov   wc.hIcon,eax
    mov   wc.hIconSm,eax
    invoke LoadCursor,NULL,IDC_ARROW
    mov   wc.hCursor,eax
    invoke RegisterClassEx, addr wc
    ; center main screen
    invoke GetSystemMetrics,SM_CXSCREEN
    xor edx, edx
    mov ecx, 2
    div ecx
    sub eax, 320
    push eax
    invoke GetSystemMetrics,SM_CYSCREEN
    xor edx, edx
    mov ecx, 2
    div ecx
    sub eax, 240
    pop ebx
    INVOKE CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassName,ADDR AppName,\
           WS_OVERLAPPEDWINDOW,ebx,\;CW_USEDEFAULT,\
           eax,640,480,NULL,NULL,\
           hInst,NULL
    mov   hwndMain,eax
    INVOKE ShowWindow, hwndMain,SW_SHOWNORMAL
    INVOKE UpdateWindow, hwndMain
    .WHILE TRUE
                INVOKE GetMessage, ADDR msg,NULL,0,0
                .BREAK .IF (!eax)
                INVOKE TranslateMessage, ADDR msg
                INVOKE DispatchMessage, ADDR msg
    .ENDW
    mov     eax,msg.wParam
    ret
WinMain endp

;===============================================
;    WndProc(HWND hWnd,UINT uMsg,WPARAM wParam, LPARAM lParam)
;    Message handler callback for the main window
;    class. Window controls created when 
;    WM_CREATE message is processed.
;===============================================
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .IF uMsg==WM_DESTROY
        invoke PostQuitMessage,NULL
    .ELSEIF uMsg==WM_NOTIFY
        mov eax,lParam
        mov eax, (NMHDR PTR [eax]).code
        ChangingTab:
        mov ebx,WhichTabChosen
        mov eax,[Handles+ebx*4]
        invoke ShowWindow,eax,SW_HIDE
        invoke SendMessage,hwndTabControl,TCM_GETCURSEL,0,0
        mov WhichTabChosen,eax
        mov EBX,[Handles+eax*4]
         invoke ShowWindow,ebx,SW_SHOWDEFAULT
         ;RET        
    .ELSEIF uMsg==WM_CREATE

        invoke InitCommonControls
        
        invoke CreateWindowEx,NULL, ADDR TabClassName,NULL,WS_CHILD or WS_VISIBLE,0,0,640,480,hWnd,TabMainID,hInstance,NULL
        mov hwndTabControl, eax
        
        mov ItemStruct.imask,TCIF_TEXT
        mov ItemStruct.lpReserved1,0
        mov ItemStruct.lpReserved2,0
        mov ItemStruct.pszText,OFFSET TabTitle1 
        mov ItemStruct.cchTextMax,sizeof TabTitle1
          mov ItemStruct.iImage,0 
         mov ItemStruct.lParam,0
        invoke SendMessage,hwndTabControl,TCM_INSERTITEM,0,OFFSET ItemStruct
        
        mov ItemStruct.pszText,OFFSET TabTitle2
        mov ItemStruct.cchTextMax,sizeof TabTitle2
        invoke SendMessage,hwndTabControl,TCM_INSERTITEM,1,OFFSET ItemStruct
        .if defuser.ulevel == 1
            mov ItemStruct.pszText,OFFSET TabTitle3
            mov ItemStruct.cchTextMax,sizeof TabTitle3
            invoke SendMessage,hwndTabControl,TCM_INSERTITEM,2,OFFSET ItemStruct
        .endif

        ;======= tab1
        invoke CreateWindowEx,NULL,ADDR StaticClassName,NULL,\
            WS_CHILD OR ES_LEFT OR WS_VISIBLE,\
            0,30,2000,2000,hwndTabControl,NULL,hInstance,NULL
        mov hndTab1, eax

        invoke ListBox,10,10,300,400,hndTab1,22
        mov hndVehicleList, eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov deflistproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,offset ListBoxProc
        invoke UpdateVehicleDisplay
        
        ;rego
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
            WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
            ES_AUTOHSCROLL,\
            360,10,80,25,hndTab1,editidvehiclerego,hInstance,NULL
        mov  hwndEditVehicleRego,eax
        
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or ES_LEFT,\
                        320,15,40,25,hndTab1,staticidvehiclerego,hInstance,NULL
        mov hwndStaticVehicleRego,eax
        invoke SendMessage,hwndStaticVehicleRego,WM_SETTEXT,0,ADDR staticvehicleregotext
        ;make
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
            WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
            ES_AUTOHSCROLL,\
            360,40,80,25,hndTab1,editidvehiclemake,hInstance,NULL
        mov  hwndEditVehicleMake,eax
        
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or ES_LEFT,\
                        320,45,40,25,hndTab1,staticidvehiclemake,hInstance,NULL
        mov hwndStaticVehicleMake,eax
        invoke SendMessage,hwndStaticVehicleMake,WM_SETTEXT,0,ADDR staticvehiclemaketext
        ;model
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
            WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
            ES_AUTOHSCROLL,\
            495,40,125,25,hndTab1,editidvehiclemodel,hInstance,NULL
        mov  hwndEditVehicleModel,eax
        
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or ES_LEFT,\
                        445,45,50,25,hndTab1,staticidvehiclemodel,hInstance,NULL
        mov hwndStaticVehicleModel,eax
        invoke SendMessage,hwndStaticVehicleModel,WM_SETTEXT,0,ADDR staticvehiclemodeltext
        ;salesman
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
            WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
            ES_AUTOHSCROLL,\
            390,70,230,25,hndTab1,editidvehiclesalesman,hInstance,NULL
        mov  hwndEditVehicleSalesman,eax
        
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or ES_LEFT,\
                        320,75,70,25,hndTab1,staticidvehiclesalesman,hInstance,NULL
        mov hwndStaticVehicleSalesman,eax
        invoke SendMessage,hwndStaticVehicleSalesman,WM_SETTEXT,0,ADDR staticvehiclesalesmantext
        ;delete button
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextDelete,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        320,120,60,25,hndTab1,buttonidvehicledelete,hInstance,NULL
        mov  hwndButtonVehicleDelete,eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov defbuttonproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,addr DeleteVehicleProc
        ;add button
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextAdd,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        400,120,60,25,hndTab1,buttonidvehicleadd,hInstance,NULL
        mov  hwndButtonVehicleAdd,eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov defbuttonproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,addr AddVehicleProc
        ;update button
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextUpdate,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        480,120,60,25,hndTab1,buttonidvehicleupdate,hInstance,NULL
        mov  hwndButtonVehicleUpdate,eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov defbuttonproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,addr UpdateVehicleProc
        ;clear button
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextClear,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        560,120,60,25,hndTab1,buttonidvehicleclear,hInstance,NULL
        mov  hwndButtonVehicleClear,eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov defbuttonproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,addr ClearVehicleProc


        ;======= tab2
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
            WS_CHILD or ES_LEFT,\ ; cant be visible
            0,30,2000,2000,hwndTabControl,NULL,hInstance,NULL
        mov hndTab2, eax
        invoke SendMessage,hwndMain,WM_NOTIFY,NULL,NULL
        invoke GetWindowLong,hndTab2,GWL_WNDPROC
        mov defstaticproc, eax
        invoke SetWindowLong,hndTab2,GWL_WNDPROC,addr StaticProc
        invoke ListBox,10,10,300,400,hndTab2,23
        mov hndUserList, eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov deflistproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,offset ListBoxProc
        invoke UpdateUserDisplay
        
        ;ulevel
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR ComboClassName,NULL,\
            WS_CHILD or WS_VISIBLE or WS_BORDER or CBS_DROPDOWNLIST,\
            360,10,80,200,hndTab2,comboiduserlevel,hInstance,NULL
        mov  hwndComboUserLevel,eax
        invoke SendMessage,hwndComboUserLevel,CB_ADDSTRING,0,addr admintext
        invoke SendMessage,hwndComboUserLevel,CB_ADDSTRING,0,addr managertext
        invoke SendMessage,hwndComboUserLevel,CB_ADDSTRING,0,addr salestext
        invoke SendMessage,hwndComboUserLevel,CB_SELECTSTRING,2,addr salestext
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or ES_LEFT,\
                        320,15,40,25,hndTab2,NULL,hInstance,NULL
        invoke SendMessage,eax,WM_SETTEXT,0,ADDR staticuserleveltext
        ;username
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
            WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
            ES_AUTOHSCROLL,\
            400,40,185,25,hndTab2,NULL,hInstance,NULL
        mov  hwndEditUserName,eax
        
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or ES_LEFT,\
                        320,45,75,25,hndTab2,NULL,hInstance,NULL
        invoke SendMessage,eax,WM_SETTEXT,0,ADDR staticusernametext
        
        ;userpass
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
            WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
            ES_AUTOHSCROLL,\
            400,70,185,25,hndTab2,NULL,hInstance,NULL
        mov  hwndEditUserPass,eax
        invoke SendMessage,eax,EM_SETPASSWORDCHAR,'*',0
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or ES_LEFT,\
                        320,75,75,25,hndTab2,NULL,hInstance,NULL
        invoke SendMessage,eax,WM_SETTEXT,0,ADDR staticuserpasstext

        ;delete button
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextDelete,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        320,120,60,25,hndTab2,NULL,hInstance,NULL
        mov  hwndButtonUserDelete,eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov defbuttonproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,addr DeleteUserProc
        ;add button
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextAdd,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        400,120,60,25,hndTab2,NULL,hInstance,NULL
        mov  hwndButtonUserAdd,eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov defbuttonproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,addr AddUserProc
        ;update button
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextUpdate,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        480,120,60,25,hndTab2,NULL,hInstance,NULL
        mov  hwndButtonUserUpdate,eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov defbuttonproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,addr UpdateUserProc
        ;clear button
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextClear,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        560,120,60,25,hndTab2,NULL,hInstance,NULL
        mov  hwndButtonUserClear,eax
        push eax
        invoke GetWindowLong,eax,GWL_WNDPROC
        mov defbuttonproc, eax
        pop eax
        invoke SetWindowLong,eax,GWL_WNDPROC,addr ClearUserProc

        ;======= tab3
        .if defuser.ulevel == 1 ;only create Dealership tab item if logged in user is administrator
            invoke CreateWindowEx,NULL,ADDR StaticClassName,NULL,\
                WS_CHILD OR ES_LEFT,\ ; cant be visible
                0,30,2000,2000,hwndTabControl,NULL,hInstance,NULL
            mov hndTab3, eax
                
            invoke ListBox,10,10,300,400,hndTab3,24
            mov hndDealerList, eax
            push eax
            invoke GetWindowLong,eax,GWL_WNDPROC
            mov deflistproc, eax
            pop eax
            invoke SetWindowLong,eax,GWL_WNDPROC,offset ListBoxProc
            invoke UpdateDealerDisplay
            ;name
            invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
                WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                ES_AUTOHSCROLL,\
                390,40,125,25,hndTab3,NULL,hInstance,NULL
            mov  hwndEditDealerName,eax
            
            invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                            WS_CHILD or WS_VISIBLE or ES_LEFT,\
                            320,45,45,25,hndTab3,NULL,hInstance,NULL
            invoke SendMessage,eax,WM_SETTEXT,0,ADDR staticdealernametext
            ;manager
            invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
                WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                ES_AUTOHSCROLL,\
                390,70,125,25,hndTab3,NULL,hInstance,NULL
            mov  hwndEditDealerManager,eax
            
            invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                            WS_CHILD or WS_VISIBLE or ES_LEFT,\
                            320,75,60,25,hndTab3,NULL,hInstance,NULL
            invoke SendMessage,eax,WM_SETTEXT,0,ADDR staticdealermanagertext
            ;address
            invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
                WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                ES_AUTOHSCROLL,\
                390,100,230,25,hndTab3,NULL,hInstance,NULL
            mov  hwndEditDealerAddress,eax
            
            invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                            WS_CHILD or WS_VISIBLE or ES_LEFT,\
                            320,105,60,25,hndTab3,NULL,hInstance,NULL
            invoke SendMessage,eax,WM_SETTEXT,0,ADDR staticdealeraddresstext
            ;delete button
            invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextDelete,\
                            WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                            320,140,60,25,hndTab3,NULL,hInstance,NULL
            mov  hwndButtonDealerDelete,eax
            push eax
            invoke GetWindowLong,eax,GWL_WNDPROC
            mov defbuttonproc, eax
            pop eax
            invoke SetWindowLong,eax,GWL_WNDPROC,addr DeleteDealerProc
            ;add button
            invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextAdd,\
                            WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                            400,140,60,25,hndTab3,NULL,hInstance,NULL
            mov  hwndButtonDealerAdd,eax
            push eax
            invoke GetWindowLong,eax,GWL_WNDPROC
            mov defbuttonproc, eax
            pop eax
            invoke SetWindowLong,eax,GWL_WNDPROC,addr AddDealerProc
            ;update button
            invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextUpdate,\
                            WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                            480,140,60,25,hndTab3,NULL,hInstance,NULL
            mov  hwndButtonDealerUpdate,eax
            push eax
            invoke GetWindowLong,eax,GWL_WNDPROC
            mov defbuttonproc, eax
            pop eax
            invoke SetWindowLong,eax,GWL_WNDPROC,addr UpdateDealerProc
            ;clear button
            invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextClear,\
                            WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                            560,140,60,25,hndTab3,NULL,hInstance,NULL
            mov  hwndButtonDealerClear,eax
            push eax
            invoke GetWindowLong,eax,GWL_WNDPROC
            mov defbuttonproc, eax
            pop eax
            invoke SetWindowLong,eax,GWL_WNDPROC,addr ClearDealerProc
        .endif
    
    .ELSEIF uMsg==WM_COMMAND
        mov eax,wParam
        .IF lParam==0
            .IF ax==IDM_CLEAR
                invoke SetWindowText,hwndEdit,NULL
            .ELSEIF  ax==IDM_GETTEXT
                invoke GetWindowText,hwndEdit,ADDR buffer,512
                invoke MessageBox,NULL,ADDR buffer,ADDR AppName,MB_OK
            .ELSE
                invoke DestroyWindow,hWnd
            .ENDIF
        .ELSE
            .IF ax==ButtonID
                shr eax,16
                .IF ax==BN_CLICKED
                    invoke SendMessage,hWnd,WM_COMMAND,IDM_GETTEXT,0
                .ENDIF
            .ENDIF            
        .ENDIF
    .ELSE
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam
        ret
    .ENDIF
    xor    eax,eax
    ret
WndProc endp

;===============================================
;    VerifyDB()
;    Called upon application init. Checks
;    existance of the 3 database files and will
;    re-create those which do not exist.
;===============================================
VerifyDB proc
    ; user db
    invoke CreateFile,addr userdbname,GENERIC_READ or GENERIC_WRITE,0,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
    mov userdbhnd, eax
    invoke GetFileSize,userdbhnd,0
    test eax, eax
    jnz @f
        invoke CreateUserDB
    @@:
    ; vehicle db
    invoke CreateFile,addr vehicledbname,GENERIC_READ or GENERIC_WRITE,0,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
    mov vehicledbhnd, eax
    invoke GetFileSize,vehicledbhnd,0
    test eax, eax
    jnz @f
        invoke CreateVehicleDB
    @@:
    ; dealership db
    invoke CreateFile,addr dealerdbname,GENERIC_READ or GENERIC_WRITE,0,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
    mov dealerdbhnd, eax
    invoke GetFileSize,dealerdbhnd,0
    test eax, eax
    jnz @f
        invoke CreateDealerDB
    @@:
    ret
VerifyDB endp

;===============================================
;    CreateUserDB()
;    Called upon new user db file creation,
;    allows addition of test user entries.
;===============================================
CreateUserDB proc
    invoke AddUser,defuser
    invoke AddUser,testuser
    invoke FindUser,defuser
    ret
CreateUserDB endp

;===============================================
;    AddUser(USER user)
;    Adds user object to user database.
;===============================================
AddUser proc user:USER
    LOCAL nobr:DWORD
    invoke WriteFile,userdbhnd,addr user,SIZEOF(USER),addr nobr,0
    ret
AddUser endp

;===============================================
;    FindUser(USER searchuser)
;    Searches the user database for the
;    user object passed and fills the fileuser
;    object with any matching entries found.
;===============================================
FindUser proc searchuser:USER
    LOCAL nobr:DWORD
    LOCAL bfound:BYTE
    mov bfound, 0
    invoke SetFilePointer,userdbhnd,0,0,FILE_BEGIN
    .IF byte ptr [searchuser.uname] == 0
        mov eax, -1
        ret
    .ENDIF
    .WHILE !bfound
        invoke ReadFile,userdbhnd,addr fileuser,SIZEOF(USER),addr nobr,0
        .BREAK .IF (dword ptr [nobr] != SIZEOF(USER))
        xor ecx, ecx
        .WHILE ecx < 20
            .IF byte ptr [fileuser.uname+ecx] == 0
                mov bfound, 1
                .BREAK
            .ENDIF
            mov al, byte ptr[fileuser.uname+ecx]
            mov bl, byte ptr[searchuser.uname+ecx]
            .IF al != bl
                .BREAK
            .ENDIF
            inc ecx
        .ENDW
    .ENDW
    mov al, bfound
    ret
FindUser endp

;===============================================
;    UpdateUserisplay()
;    Updates the user list in the users tab
;    to reflect the user database file. Called
;    when any changes to the user database are 
;    made.
;===============================================
UpdateUserDisplay proc
    LOCAL nobr:DWORD
    invoke SendMessage,hndUserList,LB_GETCOUNT,0,0
    mov esi, eax
    .while esi > 0
        invoke SendMessage,hndUserList,LB_DELETESTRING,0,0
        dec esi
    .endw
    invoke SpaceFillDisplayUser
    invoke SetFilePointer,userdbhnd,0,0,FILE_BEGIN
    @@:
    invoke ReadFile,userdbhnd,addr displayuser,SIZEOF(USER),addr nobr,0
    .IF (dword ptr [nobr] == SIZEOF(USER))
        mov ecx, SIZEOF(USER)
        mov esi, offset displayuser
        pushad
        mov dword ptr [displayuserlevel], 20202020h
        mov dword ptr [displayuserlevel+4], 20202020h
        .if byte ptr [esi] == 1
            mov eax, dword ptr [admintext]
            mov dword ptr [displayuserlevel], eax
            mov al, byte ptr [admintext+4]
            mov byte ptr [displayuserlevel+4], al
        .elseif byte ptr [esi] == 2
            mov eax, dword ptr [managertext]
            mov dword ptr [displayuserlevel], eax
            mov ax, word ptr [managertext+4]
            mov word ptr [displayuserlevel+4], ax
            mov al, byte ptr [managertext+6]
            mov byte ptr [displayuserlevel+6], al
        .else
            mov eax, dword ptr [salestext]
            mov dword ptr [displayuserlevel], eax
            mov al, byte ptr [salestext+4]
            mov byte ptr [displayuserlevel+4], al
        .endif
        popad
        mov byte ptr [esi], 20h
        .WHILE ecx != 0
            .IF byte ptr [esi] == 0
                mov byte ptr [esi],20h
            .ENDIF
            inc esi
            dec ecx
        .endw
        mov esi, offset displayuser
        add esi, 21
        mov byte ptr [esi],0
        invoke SendMessage,hndUserList,LB_ADDSTRING,0,addr displayuserlevel
        jmp @b
    .ENDIF
    ret
UpdateUserDisplay endp

;===============================================
;    SpaceFillDisplayUser()
;    Clears the user display object for 
;    processing of the next user object in the
;    user database file.
;===============================================
SpaceFillDisplayUser proc
    mov esi, offset displayuser
    mov ecx, sizeof(USER)
    .WHILE ecx != 0
        mov byte ptr [esi],20h
        dec ecx
    .endw
    ret
SpaceFillDisplayUser endp

;===============================================
;    GetUserAtIndex(dword index)
;    Retrives the user object at specified
;    index and loads it into the fileuser
;    struct.
;===============================================
GetUserAtIndex proc index :DWORD
    LOCAL nobr :DWORD
    mov eax, index
    xor edx, edx
    mov ecx, SIZEOF(USER)
    mul ecx
    invoke SetFilePointer,userdbhnd,eax,edx,FILE_BEGIN
    invoke ReadFile,userdbhnd,addr fileuser,SIZEOF(USER),addr nobr,0
    ret
GetUserAtIndex endp

;===============================================
;    DeleteUserProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Processes windows control messages for the
;    delete button. If the control message alerts
;    that the delete button has been pressed, the
;    user object selected will be deleted. 
;===============================================
DeleteUserProc proc hCtl   :DWORD,
                 uMsg   :DWORD,
                 wParam :DWORD,
                 lParam :DWORD

    LOCAL listsel        :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke SendMessage,hndUserList,LB_GETCURSEL,0,0
        mov listsel, eax
        .if eax != LB_ERR
            invoke DeleteUser,listsel
            invoke UpdateUserDisplay
            invoke MessageBox,NULL,addr userdeleted, addr nulltermchar,MB_OK
            invoke SetWindowText,hwndEditUserName,addr nulltermchar
            invoke SetWindowText,hwndEditUserPass,addr nulltermchar
            invoke SendMessage,hwndComboUserLevel,CB_SELECTSTRING,2,addr salestext
        .endif
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
DeleteUserProc endp

;===============================================
;    DeleteUser(dword listsel)
;    Deletes the user object at the specified
;    index (gathered from the selected user in
;    the user list.
;===============================================
DeleteUser proc listsel:DWORD
    LOCAL nobr            :DWORD
    LOCAL newsize        :DWORD
    LOCAL newsizehigh    :DWORD
    LOCAL numbefore        :DWORD
    LOCAL delmem        :DWORD
    mov eax, listsel
    push eax
    invoke GetFileSize,userdbhnd,addr newsizehigh
    sub eax, SIZEOF(USER)
    mov newsize, eax
    invoke VirtualAlloc,NULL,eax,MEM_COMMIT,PAGE_READWRITE
    mov delmem, eax
    pop eax
    xor edx, edx
    mov ecx, SIZEOF(USER)
    mul ecx ;eax now contains number of bytes to write before deleted record
    mov numbefore, eax
    invoke SetFilePointer,userdbhnd,0,0,FILE_BEGIN
    invoke ReadFile,userdbhnd,delmem,numbefore,addr nobr,NULL
    invoke SetFilePointer,userdbhnd,SIZEOF(USER),0,FILE_CURRENT
    mov ebx, delmem
    add ebx, nobr            
    mov edx, newsize
    sub edx, numbefore
    invoke ReadFile,userdbhnd,ebx,edx,addr nobr,NULL
    invoke CloseHandle,userdbhnd
    invoke CreateFile,addr userdbname,GENERIC_READ or GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
    mov userdbhnd, eax
    invoke WriteFile,userdbhnd,delmem,newsize,addr nobr,NULL
    invoke VirtualFree,delmem,newsize,MEM_RELEASE
    ret
DeleteUser endp

;===============================================
;    AddUserProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Processes windows control messages for the
;    add button. If the control message alerts
;    that the add button has been pressed, the
;    user object entered will be added to
;    the user database. 
;===============================================
AddUserProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    LOCAL user         :USER
    LOCAL nobr        :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke ClearUser,addr user
        invoke SendMessage,hwndComboUserLevel,CB_GETCURSEL,0,0
        inc eax
        mov user.ulevel, al
        invoke GetWindowText,hwndEditUserName,addr user.uname,20
        invoke GetWindowText,hwndEditUserPass,addr user.upass,20
        invoke SetFilePointer,userdbhnd,0,0,FILE_END
        invoke WriteFile,userdbhnd,addr user,SIZEOF(USER),addr nobr,NULL
        invoke UpdateUserDisplay
        invoke MessageBox,NULL,addr useradded, addr nulltermchar,MB_OK
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
AddUserProc endp

;===============================================
;    ClearUser(dword lpUser)
;    Clears the user object pointed to by
;    lpUser.
;===============================================
ClearUser proc lpUser:DWORD
    mov ecx, sizeof(USER)
    mov edi, lpUser
    .while ecx > 0
        mov byte ptr [edi],0
        dec ecx
        inc edi
    .endw
    ret
ClearUser endp

;===============================================
;    UpdateUserProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Updates the user object currently selected
;    in the user list with the updated
;    user details entered.
;===============================================
UpdateUserProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    LOCAL user        :USER
    LOCAL nobr        :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke SendMessage,hndUserList,LB_GETCURSEL,0,0
        invoke DeleteUser,eax
        invoke ClearUser,addr user
        invoke SendMessage,hwndComboUserLevel,CB_GETCURSEL,0,0
        inc eax
        mov user.ulevel, al
        invoke GetWindowText,hwndEditUserName,addr user.uname,20
        invoke GetWindowText,hwndEditUserPass,addr user.upass,20
        invoke SetFilePointer,userdbhnd,0,0,FILE_END
        invoke WriteFile,userdbhnd,addr user,SIZEOF(USER),addr nobr,NULL
        invoke UpdateUserDisplay
        invoke MessageBox,NULL,addr userupdated, addr nulltermchar,MB_OK
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
UpdateUserProc endp

;===============================================
;    ClearUserProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Processes windows control messages for the
;    clear button. If the control message alerts
;    that the clear button has been pressed, the
;    user detail entry edit boxes will be
;    cleared.
;===============================================
ClearUserProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke SendMessage,hwndComboUserLevel,CB_SELECTSTRING,2,addr salestext
        invoke SetWindowText,hwndEditUserName,addr nulltermchar
        invoke SetWindowText,hwndEditUserPass,addr nulltermchar
        invoke EnableWindow,hwndComboUserLevel,TRUE
        invoke SendMessage,hwndEditUserName,WM_ENABLE,TRUE,0
        invoke SendMessage,hwndEditUserPass,WM_ENABLE,TRUE,0
        invoke EnableWindow,hwndButtonUserUpdate,TRUE
        invoke EnableWindow,hwndButtonUserAdd,TRUE
        invoke EnableWindow,hwndButtonUserDelete,TRUE
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
ClearUserProc endp

;===============================================
;    CreateVehicleDB()
;    Called upon new vehicle db file creation,
;    allows addition of test vehicle entries.
;===============================================
CreateVehicleDB proc
    invoke AddVehicle,testvehicle
    invoke AddVehicle,testvehicle2
    invoke AddVehicle,testvehicle3
    ret
CreateVehicleDB endp

;===============================================
;    AddVehicle(VEHICLE vehicle)
;    Adds vehicle object to vehicle database.
;===============================================
AddVehicle proc vehicle:VEHICLE
    LOCAL nobr:DWORD
    invoke WriteFile,vehicledbhnd,addr vehicle,SIZEOF(VEHICLE),addr nobr,0
    ret
AddVehicle endp

;===============================================
;    UpdateVehicleDisplay()
;    Updates the vehicle list in the vehicle tab
;    to reflect the vehicle database file. Called
;    when any changes to the vehicle database are 
;    made.
;===============================================
UpdateVehicleDisplay proc
    LOCAL nobr:DWORD
    invoke SendMessage,hndVehicleList,LB_GETCOUNT,0,0
    mov esi, eax
    .while esi > 0
        invoke SendMessage,hndVehicleList,LB_DELETESTRING,0,0
        dec esi
    .endw
    invoke SpaceFillDisplayVehicle
    invoke SetFilePointer,vehicledbhnd,0,0,FILE_BEGIN
    @@:
    invoke ReadFile,vehicledbhnd,addr displayvehicle,SIZEOF(VEHICLE),addr nobr,0
    .IF (dword ptr [nobr] == SIZEOF(VEHICLE))
        mov ecx, SIZEOF(VEHICLE)
        mov esi, offset displayvehicle
        .WHILE ecx != 0
            .IF byte ptr [esi] == 0
                mov byte ptr [esi],20h
            .ENDIF
            inc esi
            dec ecx
        .endw
        invoke SendMessage,hndVehicleList,LB_ADDSTRING,0,addr displayvehicle
        jmp @b
    .ENDIF
    ret
UpdateVehicleDisplay endp

;===============================================
;    SpaceFillDisplayVehicle()
;    Clears the vehicle display object for 
;    processing of the next vehicle object in the
;    vehicle database file.
;===============================================
SpaceFillDisplayVehicle proc
    mov esi, offset displayvehicle
    mov ecx, sizeof(VEHICLE)
    .WHILE ecx != 0
        mov byte ptr [esi],20h
        dec ecx
    .endw
    ret
SpaceFillDisplayVehicle endp

;===============================================
;    GetVehicleAtIndex(dword index)
;    Retrieves the vehicle object at specified
;    index and loads it into the filevehicle
;    struct.
;===============================================
GetVehicleAtIndex proc index :DWORD
    LOCAL nobr :DWORD
    mov eax, index
    xor edx, edx
    mov ecx, SIZEOF(VEHICLE)
    mul ecx
    invoke SetFilePointer,vehicledbhnd,eax,edx,FILE_BEGIN
    invoke ReadFile,vehicledbhnd,addr filevehicle,SIZEOF(VEHICLE),addr nobr,0
    ret
GetVehicleAtIndex endp

;===============================================
;    DeleteVehicleProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Processes windows control messages for the
;    delete button. If the control message alerts
;    that the delete button has been pressed, the
;    vehicle object selected will be deleted. 
;===============================================
DeleteVehicleProc proc hCtl   :DWORD,
        uMsg   :DWORD,
        wParam :DWORD,
        lParam :DWORD
    LOCAL listsel    :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke SendMessage,hndVehicleList,LB_GETCURSEL,0,0
        mov listsel, eax
        .if eax != LB_ERR
            invoke DeleteVehicle,listsel
            invoke UpdateVehicleDisplay
            invoke MessageBox,NULL,addr vehicledeleted, addr nulltermchar,MB_OK
            invoke SetWindowText,hwndEditVehicleRego,addr nulltermchar
            invoke SetWindowText,hwndEditVehicleMake,addr nulltermchar
            invoke SetWindowText,hwndEditVehicleModel,addr nulltermchar
            invoke SetWindowText,hwndEditVehicleSalesman,addr nulltermchar
        .endif
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
DeleteVehicleProc endp

;===============================================
;    DeleteVehicle(dword listsel)
;    Deletes the vehicle object at the specified
;    index (gathered from the selected vehicle in
;    the vehicle list.
;===============================================
DeleteVehicle proc listsel:DWORD
    LOCAL nobr            :DWORD
    LOCAL newsize        :DWORD
    LOCAL newsizehigh    :DWORD
    LOCAL numbefore        :DWORD
    LOCAL delmem        :DWORD
    mov eax, listsel
    push eax
    invoke GetFileSize,vehicledbhnd,addr newsizehigh
    sub eax, SIZEOF(VEHICLE)
    mov newsize, eax
    invoke VirtualAlloc,NULL,eax,MEM_COMMIT,PAGE_READWRITE
    mov delmem, eax
    pop eax
    xor edx, edx
    mov ecx, SIZEOF(VEHICLE)
    mul ecx ;eax now contains number of bytes to write before deleted record
    mov numbefore, eax
    invoke SetFilePointer,vehicledbhnd,0,0,FILE_BEGIN
    invoke ReadFile,vehicledbhnd,delmem,numbefore,addr nobr,NULL
    invoke SetFilePointer,vehicledbhnd,SIZEOF(VEHICLE),0,FILE_CURRENT
    mov ebx, delmem
    add ebx, nobr            
    mov edx, newsize
    sub edx, numbefore
    invoke ReadFile,vehicledbhnd,ebx,edx,addr nobr,NULL
    invoke CloseHandle,vehicledbhnd
    invoke CreateFile,addr vehicledbname,GENERIC_READ or GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
    mov vehicledbhnd, eax
    invoke WriteFile,vehicledbhnd,delmem,newsize,addr nobr,NULL
    invoke VirtualFree,delmem,newsize,MEM_RELEASE
    ret
DeleteVehicle endp

;===============================================
;    AddVehicleProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Processes windows control messages for the
;    add button. If the control message alerts
;    that the add button has been pressed, the
;    vehicle object entered will be added to
;    the vehicle database. 
;===============================================
AddVehicleProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    LOCAL vehicle     :VEHICLE
    LOCAL nobr        :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke ClearVehicle,addr vehicle
        invoke GetWindowText,hwndEditVehicleRego,addr vehicle.rego,8
        invoke GetWindowText,hwndEditVehicleMake,addr vehicle.make,10
        invoke GetWindowText,hwndEditVehicleModel,addr vehicle.model,15
        invoke GetWindowText,hwndEditVehicleSalesman,addr vehicle.salesman,20
        invoke SetFilePointer,vehicledbhnd,0,0,FILE_END
        invoke WriteFile,vehicledbhnd,addr vehicle,SIZEOF(VEHICLE),addr nobr,NULL
        invoke UpdateVehicleDisplay
        invoke MessageBox,NULL,addr vehicleadded, addr nulltermchar,MB_OK
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
AddVehicleProc endp

;===============================================
;    ClearVehicle(dword lpVehicle)
;    Clears the vehicle object pointed to by
;    lpVehicle.
;===============================================
ClearVehicle proc lpVehicle:DWORD
    mov ecx, sizeof(VEHICLE)
    mov edi, lpVehicle
    .while ecx > 0
        mov byte ptr [edi],0
        dec ecx
        inc edi
    .endw
    ret
ClearVehicle endp

;===============================================
;    UpdateVehicleProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Updates the vehicle object currently selected
;    in the vehicle list with the updated
;    vehicle details entered.
;===============================================
UpdateVehicleProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    LOCAL vehicle    :VEHICLE
    LOCAL nobr        :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke SendMessage,hndVehicleList,LB_GETCURSEL,0,0
        invoke DeleteVehicle,eax
        invoke ClearVehicle,addr vehicle
        invoke GetWindowText,hwndEditVehicleRego,addr vehicle.rego,8
        invoke GetWindowText,hwndEditVehicleMake,addr vehicle.make,10
        invoke GetWindowText,hwndEditVehicleModel,addr vehicle.model,15
        invoke GetWindowText,hwndEditVehicleSalesman,addr vehicle.salesman,20
        invoke SetFilePointer,vehicledbhnd,0,0,FILE_END
        invoke WriteFile,vehicledbhnd,addr vehicle,SIZEOF(VEHICLE),addr nobr,NULL
        invoke UpdateVehicleDisplay
        invoke MessageBox,NULL,addr vehicleupdated, addr nulltermchar,MB_OK
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
UpdateVehicleProc endp

;===============================================
;    ClearVehicleProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Processes windows control messages for the
;    clear button. If the control message alerts
;    that the clear button has been pressed, the
;    vehicle detail entry edit boxes will be
;    cleared.
;===============================================
ClearVehicleProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke SetWindowText,hwndEditVehicleRego,addr nulltermchar
        invoke SetWindowText,hwndEditVehicleMake,addr nulltermchar
        invoke SetWindowText,hwndEditVehicleModel,addr nulltermchar
        invoke SetWindowText,hwndEditVehicleSalesman,addr nulltermchar
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
ClearVehicleProc endp

;===============================================
;    WinLogin(HINSTANCE hInst,HINSTANCE hPrevInst,LPSTR CmdLine,dword CmdShow)
;    Window creation function for the login
;    window. Window class is created and filled,
;    window is created then centred to screen
;    dimensions (works accross different 
;    resolutions). Message handler is created.
;===============================================
WinLogin proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
    LOCAL wc:WNDCLASSEX
    LOCAL msg:MSG
    mov   wc.cbSize,SIZEOF WNDCLASSEX
    mov   wc.style, CS_HREDRAW or CS_VREDRAW
    mov   wc.lpfnWndProc, OFFSET WndProcLogin
    mov   wc.cbClsExtra,NULL
    mov   wc.cbWndExtra,NULL
    push  hInst
    pop   wc.hInstance
    mov   wc.hbrBackground,COLOR_BTNFACE+1
    mov   wc.lpszMenuName,NULL
    mov   wc.lpszClassName,OFFSET ClassNameLogin
    invoke LoadIcon,NULL,IDI_APPLICATION
    mov   wc.hIcon,eax
    mov   wc.hIconSm,eax
    invoke LoadCursor,NULL,IDC_ARROW
    mov   wc.hCursor,eax
    invoke RegisterClassEx, addr wc
    ; center login screen
    invoke GetSystemMetrics,SM_CXSCREEN
    xor edx, edx
    mov ecx, 2
    div ecx
    sub eax, 160
    push eax
    invoke GetSystemMetrics,SM_CYSCREEN
    xor edx, edx
    mov ecx, 2
    div ecx
    sub eax, 100
    pop ebx
    INVOKE CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassNameLogin,ADDR AppName,\
           WS_OVERLAPPEDWINDOW,ebx,\
           eax,320,200,NULL,NULL,\
           hInst,NULL
    mov   hwndLogin,eax
    INVOKE ShowWindow, hwndLogin,SW_SHOWNORMAL
    INVOKE UpdateWindow, hwndLogin
    .WHILE TRUE
        INVOKE GetMessage, ADDR msg,NULL,0,0
        .BREAK .IF (!eax)
        INVOKE TranslateMessage, ADDR msg
        INVOKE DispatchMessage, ADDR msg
    .ENDW
    mov     eax,msg.wParam
    ret
WinLogin endp

;===============================================
;    WndProcLogin(HWND hWnd,UINT uMsg,WPARAM wParam, LPARAM lParam)
;    Message handler callback for the login
;    window class. Window controls created when 
;    WM_CREATE message is processed.
;===============================================
WndProcLogin proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .IF uMsg==WM_DESTROY
        invoke PostQuitMessage,NULL
    .ELSEIF uMsg==WM_CREATE

        invoke VerifyDB
        
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                        ES_AUTOHSCROLL,\
                        90,35,200,25,hWnd,editidusername,hInstance,NULL
        mov  hwndEditLoginUsername,eax
        
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or ES_LEFT,\
                        5,40,80,25,hWnd,staticidusername,hInstance,NULL
        mov hwndStaticLoginUsername,eax
        invoke SendMessage,hwndStaticLoginUsername,WM_SETTEXT,0,ADDR staticusernametext
        
        invoke SendMessage,hwndEditLoginUsername,EM_SETLIMITTEXT,20,0
        
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                        ES_AUTOHSCROLL,\
                        90,70,200,25,hWnd,editiduserpass,hInstance,NULL
        mov  hwndEditLoginUserpass,eax
        
        invoke CreateWindowEx,NULL, ADDR StaticClassName,NULL,\
                        WS_CHILD or WS_VISIBLE or ES_LEFT,\
                        5,75,80,25,hWnd,staticiduserpass,hInstance,NULL
        mov hwndStaticLoginUserpass,eax
        invoke SendMessage,hwndStaticLoginUserpass,WM_SETTEXT,0,ADDR staticuserpasstext        
        
        invoke SendMessage,hwndEditLoginUserpass,EM_SETLIMITTEXT,20,0
        invoke SendMessage,hwndEditLoginUserpass,EM_SETPASSWORDCHAR,'*',0
        
        invoke SetFocus, hwndEditLoginUsername
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonTextLogin,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        90,120,140,25,hWnd,buttonidlogin,hInstance,NULL
        mov  hwndButtonLogin,eax
    .ELSEIF uMsg==WM_COMMAND
        mov eax,wParam
        .IF lParam==0
            .IF ax==IDM_CLEAR
                invoke SetWindowText,hwndEditLoginUsername,NULL
            .ELSEIF  ax==IDM_GETTEXT
                invoke GetWindowText,hwndEditLoginUsername,ADDR bufuser.uname,20
                invoke GetWindowText,hwndEditLoginUserpass,ADDR bufuser.upass,20
                invoke FindUser,bufuser
                .IF eax != 0
                    ; user found, now check password against userdb
                    invoke lstrcmp,ADDR fileuser.upass,ADDR bufuser.upass
                    .IF eax == 0
                        ;-- ?invoke MessageBox,NULL,ADDR loginsuccess,ADDR AppName,MB_OK
                        mov al, fileuser.ulevel
                        mov userlevel, al
                        invoke lstrcpy,ADDR TitleUserInfo,ADDR fileuser.uname
                        invoke lstrlen,ADDR fileuser.uname
                        mov ebx, offset TitleUserInfo
                        add ebx, eax
                        mov byte ptr [ebx],20h
                        inc ebx
                        .IF fileuser.ulevel == USERLEVEL_ADMIN
                            mov esi, offset userleveladmin
                        .ELSEIF fileuser.ulevel == USERLEVEL_MANAGER
                            mov esi, offset userlevelmanager
                        .ELSE
                            mov esi, offset userlevelsales
                        .ENDIF
                        invoke lstrcpy,ebx,esi
                        mov ecx, SIZEOF(USER)
                        mov esi, offset fileuser
                        mov edi, offset defuser
                        .WHILE ecx != 0
                            mov al, byte ptr [esi]
                            mov byte ptr [edi], al
                            inc edi
                            inc esi
                            dec ecx
                        .ENDW
                        
                        invoke DestroyWindow,hwndLogin
                    .ELSE
                        invoke MessageBox,NULL,ADDR loginincorrectpass,ADDR AppName,MB_OK
                    .ENDIF
                .ELSEIF
                    ; check number of unsuccessful attempts and notify user/exit if too many
                    mov al, totalloginfailures
                    inc al
                    mov totalloginfailures, al
                    .IF al > 2
                        invoke MessageBox,NULL,ADDR toomanyfailures,ADDR AppName,MB_OK
                        invoke ExitProcess,0
                    .ENDIF
                    invoke MessageBox,NULL,ADDR loginfail,ADDR AppName,MB_YESNO
                    .IF eax == IDYES
                        invoke SetWindowText,hwndEditLoginUsername,ADDR blankstring
                        invoke SetWindowText,hwndEditLoginUserpass,ADDR blankstring
                        invoke SetFocus,hwndEditLoginUsername
                    .ELSE
                        invoke ExitProcess,0
                    .ENDIF
                .ENDIF
            .ELSE
                invoke DestroyWindow,hWnd
            .ENDIF
        .ELSE
            .IF ax==buttonidlogin
                shr eax,16
                .IF ax==BN_CLICKED
                    invoke SendMessage,hWnd,WM_COMMAND,IDM_GETTEXT,0
                .ENDIF
            .ENDIF
        .ENDIF
    .ELSE
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam
        ret
    .ENDIF
    xor    eax,eax
    ret
WndProcLogin endp

;===============================================
;    HWND ListBox(dword a,dword b,dword wd,dword ht,dword hParent,dword ID)
;    Creates a listbox with the specified
;    dimensions and parameters. eax contains
;    hwnd upon return.
;===============================================
ListBox proc a:DWORD,b:DWORD,wd:DWORD,ht:DWORD,hParent:DWORD,ID:DWORD
    szText lstBox,"LISTBOX"
    invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR lstBox,0,
              WS_VSCROLL or WS_VISIBLE or WS_HSCROLL or\
              WS_BORDER or WS_CHILD or \
              LBS_HASSTRINGS or LBS_NOINTEGRALHEIGHT or \
              LBS_DISABLENOSCROLL,
              a,b,wd,ht,hParent,ID,hInstance,NULL
    ret
ListBox endp

;===============================================
;    ListBoxProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Message handler callback for list boxes.
;    Updates selection info in relevant edit
;    box fields for associated tab/list.
;===============================================
ListBoxProc proc hCtl   :DWORD,
                 uMsg   :DWORD,
                 wParam :DWORD,
                 lParam :DWORD
    LOCAL IndexItem  :DWORD
    LOCAL Buffer[50] :BYTE
    mov eax, hCtl
    .if eax == hndVehicleList
        .if uMsg == WM_LBUTTONDOWN
            invoke CallWindowProc,deflistproc,hCtl,uMsg,wParam,lParam
            invoke SendMessage,hCtl,LB_GETCURSEL,0,0
            .if eax != LB_ERR
                mov IndexItem, eax
                invoke GetVehicleAtIndex,eax
                invoke SetWindowText,hwndEditVehicleRego,addr filevehicle.rego
                invoke SetWindowText,hwndEditVehicleMake,addr filevehicle.make
                invoke SetWindowText,hwndEditVehicleModel,addr filevehicle.model
                invoke SetWindowText,hwndEditVehicleSalesman,addr filevehicle.salesman
            .endif
            ret
        .endif
    .elseif eax == hndUserList
        .if uMsg == WM_LBUTTONDOWN
            invoke CallWindowProc,deflistproc,hCtl,uMsg,wParam,lParam
            invoke SendMessage,hCtl,LB_GETCURSEL,0,0
            .if eax != LB_ERR
                mov IndexItem, eax
                invoke GetUserAtIndex,eax
                xor eax, eax
                mov al, fileuser.ulevel
                dec eax
                invoke SendMessage,hwndComboUserLevel,CB_SETCURSEL,eax,0
                invoke SetWindowText,hwndEditUserName,addr fileuser.uname
                invoke SetWindowText,hwndEditUserPass,addr fileuser.upass
                .if defuser.ulevel > 1
                    .if fileuser.ulevel < 3
                        invoke EnableWindow,hwndComboUserLevel,FALSE
                        invoke SendMessage,hwndEditUserName,WM_ENABLE,FALSE,0
                        invoke SendMessage,hwndEditUserPass,WM_ENABLE,FALSE,0
                        invoke EnableWindow,hwndButtonUserUpdate,FALSE
                        invoke EnableWindow,hwndButtonUserAdd,FALSE
                        invoke EnableWindow,hwndButtonUserDelete,FALSE
                    .endif
                    invoke EnableWindow,hwndComboUserLevel,TRUE
                    invoke SendMessage,hwndEditUserName,WM_ENABLE,TRUE,0
                    invoke SendMessage,hwndEditUserPass,WM_ENABLE,TRUE,0
                    invoke EnableWindow,hwndButtonUserUpdate,TRUE
                    invoke EnableWindow,hwndButtonUserAdd,TRUE
                    invoke EnableWindow,hwndButtonUserDelete,TRUE
                .endif
            .endif
        .endif
    .elseif eax == hndDealerList
        .if uMsg == WM_LBUTTONDOWN
            invoke CallWindowProc,deflistproc,hCtl,uMsg,wParam,lParam
            invoke SendMessage,hCtl,LB_GETCURSEL,0,0
            .if eax != LB_ERR
                mov IndexItem, eax
                invoke GetDealerAtIndex,eax
                invoke SetWindowText,hwndEditDealerName,addr filedealer.dname
                invoke SetWindowText,hwndEditDealerManager,addr filedealer.dmanager
                invoke SetWindowText,hwndEditDealerAddress,addr filedealer.daddress
            .endif
            ret
        .endif
    .endif
    invoke CallWindowProc,deflistproc,hCtl,uMsg,wParam,lParam
    ret
ListBoxProc endp

;===============================================
;    StaticProc(HWND hWnd,UINT uMsg,WPARAM wParam, LPARAM lParam)
;    Message handler callback for the static window
;    class. Mainly used to process child control/
;    window messages.
;===============================================
StaticProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    LOCAL wasChanged    :BYTE
    LOCAL newLevel        :DWORD
    LOCAL currentSel    :DWORD
    mov wasChanged, 0
    mov eax, hCtl
    .if eax == hndTab2
    mov eax, wParam
    shr eax, 16
        .if ax == CBN_SELCHANGE
            mov wasChanged, 1
            invoke SendMessage,hwndComboUserLevel,CB_GETCURSEL,0,0
            mov currentSel, eax
        .endif
    .endif
    invoke CallWindowProc,defstaticproc,hCtl,uMsg,wParam,lParam
    .if wasChanged == 1
        invoke SendMessage,hwndComboUserLevel,CB_GETCURSEL,0,0
        inc eax
        mov newLevel, eax
        .if defuser.ulevel > 1
            .if defuser.ulevel >= al
                invoke SendMessage,hwndComboUserLevel,CB_SETCURSEL,2,0
                invoke MessageBox,hwndMain,addr usercmbmsg,addr AppName,MB_OK
                ret
            .endif
        .endif
    .endif
    ret
StaticProc endp

;===============================================
;    CreateDealerDB()
;    Called upon new dealership db file creation,
;    allows addition of test dealership entries.
;===============================================
CreateDealerDB proc
    invoke AddDealer,testdealer
    ret
CreateDealerDB endp

;===============================================
;    AddDealer(DEALER dealer)
;    Adds dealer object to dealer database.
;===============================================
AddDealer proc dealer:DEALER
    LOCAL nobr:DWORD
    invoke WriteFile,dealerdbhnd,addr dealer,SIZEOF(DEALER),addr nobr,0
    ret
AddDealer endp

;===============================================
;    UpdateDealerDisplay()
;    Updates the dealer list in the dealer tab
;    to reflect the dealer database file. Called
;    when any changes to the dealer database are 
;    made.
;===============================================
UpdateDealerDisplay proc
    LOCAL nobr:DWORD
    invoke SendMessage,hndDealerList,LB_GETCOUNT,0,0
    mov esi, eax
    .while esi > 0
        invoke SendMessage,hndDealerList,LB_DELETESTRING,0,0
        dec esi
    .endw
    invoke SpaceFillDisplayDealer
    invoke SetFilePointer,dealerdbhnd,0,0,FILE_BEGIN
    @@:
    invoke ReadFile,dealerdbhnd,addr displaydealer,SIZEOF(DEALER),addr nobr,0
    .IF (dword ptr [nobr] == SIZEOF(DEALER))
        mov ecx, SIZEOF(DEALER)
        mov esi, offset displaydealer
        .WHILE ecx != 0
            .IF byte ptr [esi] == 0
                mov byte ptr [esi],20h
            .ENDIF
            inc esi
            dec ecx
        .endw
        invoke SendMessage,hndDealerList,LB_ADDSTRING,0,addr displaydealer
        jmp @b
    .ENDIF
    ret
UpdateDealerDisplay endp

;===============================================
;    SpaceFillDisplayDealer()
;    Clears the dealer display object for 
;    processing of the next dealer object in the
;    dealer database file.
;===============================================
SpaceFillDisplayDealer proc
    mov esi, offset displaydealer
    mov ecx, sizeof(DEALER)
    .WHILE ecx != 0
        mov byte ptr [esi],20h
        dec ecx
    .endw
    ret
SpaceFillDisplayDealer endp

;===============================================
;    GetDealerAtIndex(dword index)
;    Retrives the dealership object at specified
;    index and loads it into the filedealer
;    struct.
;===============================================
GetDealerAtIndex proc index :DWORD
    LOCAL nobr :DWORD
    mov eax, index
    xor edx, edx
    mov ecx, SIZEOF(DEALER)
    mul ecx
    invoke SetFilePointer,dealerdbhnd,eax,edx,FILE_BEGIN
    invoke ReadFile,dealerdbhnd,addr filedealer,SIZEOF(DEALER),addr nobr,0
    ret
GetDealerAtIndex endp

;===============================================
;    DeleteDealerProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Processes windows control messages for the
;    delete button. If the control message alerts
;    that the delete button has been pressed, the
;    dealership object selected will be deleted. 
;===============================================
DeleteDealerProc proc hCtl :DWORD,
        uMsg   :DWORD,
        wParam :DWORD,
        lParam :DWORD

    LOCAL listsel    :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke SendMessage,hndDealerList,LB_GETCURSEL,0,0
        mov listsel, eax
        .if eax != LB_ERR
            invoke DeleteDealer,listsel
            invoke UpdateDealerDisplay
            invoke MessageBox,NULL,addr dealerdeleted, addr nulltermchar,MB_OK
            invoke SetWindowText,hwndEditDealerName,addr nulltermchar
            invoke SetWindowText,hwndEditDealerManager,addr nulltermchar
            invoke SetWindowText,hwndEditDealerAddress,addr nulltermchar
        .endif
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
DeleteDealerProc endp

;===============================================
;    DeleteDealer(dword listsel)
;    Deletes the dealer object at the specified
;    index (gathered from the selected dealer in
;    the dealership list.
;===============================================
DeleteDealer proc listsel :DWORD
    LOCAL nobr            :DWORD
    LOCAL newsize        :DWORD
    LOCAL newsizehigh    :DWORD
    LOCAL numbefore        :DWORD
    LOCAL delmem        :DWORD
    mov eax, listsel
    push eax
    invoke GetFileSize,dealerdbhnd,addr newsizehigh
    sub eax, SIZEOF(DEALER)
    mov newsize, eax
    invoke VirtualAlloc,NULL,eax,MEM_COMMIT,PAGE_READWRITE
    mov delmem, eax
    pop eax
    xor edx, edx
    mov ecx, SIZEOF(DEALER)
    mul ecx ;eax now contains number of bytes to write before deleted record
    mov numbefore, eax
    invoke SetFilePointer,dealerdbhnd,0,0,FILE_BEGIN
    invoke ReadFile,dealerdbhnd,delmem,numbefore,addr nobr,NULL
    invoke SetFilePointer,dealerdbhnd,SIZEOF(DEALER),0,FILE_CURRENT
    mov ebx, delmem
    add ebx, nobr            
    mov edx, newsize
    sub edx, numbefore
    invoke ReadFile,dealerdbhnd,ebx,edx,addr nobr,NULL
    invoke CloseHandle,dealerdbhnd
    invoke CreateFile,addr dealerdbname,GENERIC_READ or GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
    mov dealerdbhnd, eax
    invoke WriteFile,dealerdbhnd,delmem,newsize,addr nobr,NULL
    invoke VirtualFree,delmem,newsize,MEM_RELEASE
    ret
DeleteDealer endp

;===============================================
;    AddDealerProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Processes windows control messages for the
;    add button. If the control message alerts
;    that the add button has been pressed, the
;    dealership object entered will be added to
;    the dealership database. 
;===============================================
AddDealerProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    LOCAL dealer     :DEALER
    LOCAL nobr        :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke ClearDealer,addr dealer
        invoke GetWindowText,hwndEditDealerName,addr dealer.dname,20
        invoke GetWindowText,hwndEditDealerManager,addr dealer.dmanager,20
        invoke GetWindowText,hwndEditDealerAddress,addr dealer.daddress,30

        invoke SetFilePointer,dealerdbhnd,0,0,FILE_END
        invoke WriteFile,dealerdbhnd,addr dealer,SIZEOF(DEALER),addr nobr,NULL
        invoke UpdateDealerDisplay
        invoke MessageBox,NULL,addr dealeradded, addr nulltermchar,MB_OK
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
AddDealerProc endp

;===============================================
;    ClearDealer(dword lpDealer)
;    Clears the dealer object pointed to by
;    lpDealer.
;===============================================
ClearDealer proc lpDealer:DWORD
    mov ecx, sizeof(DEALER)
    mov edi, lpDealer
    .while ecx > 0
        mov byte ptr [edi],0
        dec ecx
        inc edi
    .endw
    ret
ClearDealer endp

;===============================================
;    UpdateDealerProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Updates the dealer object currently selected
;    in the dealership list with the updated
;    dealership details entered.
;===============================================
UpdateDealerProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    LOCAL dealer    :DEALER
    LOCAL nobr        :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke SendMessage,hndDealerList,LB_GETCURSEL,0,0
        invoke DeleteDealer,eax
        invoke ClearDealer,addr dealer
        invoke GetWindowText,hwndEditDealerName,addr dealer.dname,20
        invoke GetWindowText,hwndEditDealerManager,addr dealer.dmanager,20
        invoke GetWindowText,hwndEditDealerAddress,addr dealer.daddress,30
        invoke SetFilePointer,dealerdbhnd,0,0,FILE_END
        invoke WriteFile,dealerdbhnd,addr dealer,SIZEOF(DEALER),addr nobr,NULL
        invoke UpdateDealerDisplay
        invoke MessageBox,NULL,addr dealerupdated, addr nulltermchar,MB_OK
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
UpdateDealerProc endp

;===============================================
;    ClearDealerProc(dword hCtl,dword uMsg,dword wParam,dword lParam)
;    Processes windows control messages for the
;    clear button. If the control message alerts
;    that the clear button has been pressed, the
;    dealership detail entry edit boxes will be
;    cleared.
;===============================================
ClearDealerProc proc hCtl:DWORD,uMsg:DWORD,wParam :DWORD,lParam :DWORD
    .if uMsg == WM_LBUTTONUP
        invoke SetWindowText,hwndEditDealerName,addr nulltermchar
        invoke SetWindowText,hwndEditDealerManager,addr nulltermchar
        invoke SetWindowText,hwndEditDealerAddress,addr nulltermchar
    .endif
    invoke CallWindowProc,defbuttonproc,hCtl,uMsg,wParam,lParam
    ret
ClearDealerProc endp

end start
