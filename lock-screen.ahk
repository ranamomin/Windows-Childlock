#Requires AutoHotkey v2.0
#SingleInstance Force

global keyboardLocked := false
global mouseLocked := false
global blockedKeys := []

; KEYS TO BLOCK (U, Shift, Ctrl removed)
global keys := [
    "a","b","c","d","e","f","g","h","i","j","k","l","m",
    "n","o","p","q","r","s","t","v","w","x","y","z",
    "1","2","3","4","5","6","7","8","9","0",
    "F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12",
    "Tab","Enter","Esc","Backspace","Space","CapsLock",
    "Alt","LAlt","RAlt",
    "LWin","RWin","AppsKey","PrintScreen","ScrollLock","Pause",
    "Up","Down","Left","Right",
    "Insert","Delete","Home","End","PgUp","PgDn",
    "Numpad0","Numpad1","Numpad2","Numpad3","Numpad4",
    "Numpad5","Numpad6","Numpad7","Numpad8","Numpad9",
    "NumpadDot","NumpadDiv","NumpadMult","NumpadSub",
    "NumpadAdd","NumpadEnter"
]

;----------------------------
DoBlock(*) {
    return
}

DoBlockMouse(*) {
    return
}

;----------------------------
LockKeyboard() {
    global keyboardLocked, blockedKeys, keys
    
    if keyboardLocked
        return

    blockedKeys := []

    for key in keys {
        hk := "$*" . key
        Hotkey(hk, DoBlock, "On")
        blockedKeys.Push(hk)
    }

    keyboardLocked := true
}

;----------------------------
UnlockKeyboard() {
    global keyboardLocked, blockedKeys

    if !keyboardLocked
        return

    for hk in blockedKeys
        Hotkey(hk, "Off")

    blockedKeys := []
    keyboardLocked := false
}

;----------------------------
LockMouse() {
    global mouseLocked

    if mouseLocked
        return

    ; Block mouse buttons
    Hotkey("LButton", DoBlockMouse, "On")
    Hotkey("RButton", DoBlockMouse, "On")
    Hotkey("MButton", DoBlockMouse, "On")
    Hotkey("WheelUp", DoBlockMouse, "On")
    Hotkey("WheelDown", DoBlockMouse, "On")
    Hotkey("XButton1", DoBlockMouse, "On")
    Hotkey("XButton2", DoBlockMouse, "On")

    ; OPTIONAL: Freeze mouse movement
    ;Hotkey("*MouseMove", Func("FreezeMouse"), "On")

    mouseLocked := true
}

;----------------------------
UnlockMouse() {
    global mouseLocked

    if !mouseLocked
        return

    Hotkey("LButton", "Off")
    Hotkey("RButton", "Off")
    Hotkey("MButton", "Off")
    Hotkey("WheelUp", "Off")
    Hotkey("WheelDown", "Off")
    Hotkey("XButton1", "Off")
    Hotkey("XButton2", "Off")

    ; OPTIONAL: unfreeze mouse movement
    ;Hotkey("*MouseMove", "Off")

    mouseLocked := false
}

;----------------------------
; OPTIONAL: freezes cursor in place
FreezeMouse(*) {
    MouseGetPos &x, &y
    MouseMove x, y, 0
}

;----------------------------
; MASTER LOCK
LockAll() {
    LockKeyboard()
    LockMouse()
    TrayTip("LOCKED", "Keyboard + Mouse locked", 3)
}

UnlockAll() {
    UnlockKeyboard()
    UnlockMouse()
    TrayTip("UNLOCKED", "Inputs restored", 3)
}

;----------------------------
; Hotkeys
F12:: LockAll()
^+u:: UnlockAll()
