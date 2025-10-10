#Requires AutoHotkey v2.0

; Win + Enter -> Launch Git Bash
#Enter::
{
    Run("C:\Program Files\Git\git-bash.exe")

    WinWait("MINGW64", , 5)  ; Wait up to 5 seconds for Git Bash window
    WinActivate("MINGW64")   ; Bring the window to foreground
}

; Caps Lock -> [
CapsLock::[

; Shift + CapsLock -> (
^CapsLock::(

; Win + B -> Launch Brave Browser
#b::
{
    Run("C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
}

; Win + Q -> Switch to previous virtual desktop (workspace left)
#q::
{
    Send("^#{Left}")
}

; Win + W -> Switch to next virtual desktop (workspace right)
#w::
{
    Send("^#{Right}")
}

; Win + C -> Launch VS Code with current File Explorer directory
#c::
{
    ; Check if File Explorer is the active window
    if WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass")
    {
        ; Save current clipboard content
        oldClipboard := A_Clipboard
        
        ; Copy the current path to clipboard using Ctrl+L then Ctrl+C
        Send("^l")  ; Focus address bar
        Sleep(50)   ; Small delay
        Send("^c")  ; Copy path
        Sleep(100)  ; Wait for clipboard
        
        ; Get the path from clipboard
        currentPath := A_Clipboard
        
        ; Restore original clipboard
        A_Clipboard := oldClipboard
        
        ; Launch VS Code with the current directory if we got a valid path
        if (currentPath != "" && !InStr(currentPath, "`n"))
        {
            ; Use your specific VS Code path
            vscodePath := "C:\Users\William\AppData\Local\Programs\Microsoft VS Code\Code.exe"
            
            if FileExist(vscodePath)
            {
                Run('"' . vscodePath . '" "' . currentPath . '"')
                return
            }
            
            ; Fallback: try the code command
            try {
                Run('code "' . currentPath . '"')
                return
            }
        }
    }
    
    ; Fallback: if not in File Explorer or path not found, launch VS Code normally
    vscodePath := "C:\Users\William\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    
    if FileExist(vscodePath)
    {
        Run('"' . vscodePath . '"')
        return
    }
    
    ; Last resort: try the command
    try {
        Run("code")
    }
}

; Win + T -> Open current directory in PowerShell terminal
#t::
{
    nvimPath := "C:\Program Files\Neovim\bin"

    EnvSet("PATH", EnvGet("PATH") . ";" . nvimPath)

    if WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass")
    {
        oldClipboard := A_Clipboard
        Send("^l")
        Sleep(50)
        Send("^c")
        Sleep(100)
        currentPath := A_Clipboard
        A_Clipboard := oldClipboard

        ; Launch PowerShell in current directory
        if (currentPath != "" && !InStr(currentPath, "`n"))
        {
            Run("powershell.exe -NoExit -Command `"Set-Location '" . currentPath . "'; ls`"")
            return
        }
    }

    ; Fallback: open PowerShell normally
    Run("powershell.exe")
}

