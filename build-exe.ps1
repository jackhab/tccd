$GitVer = $(git describe --long --tags)

$From = "TCCD by jackhab"
$To =   "TCCD by jackhab ver. $GitVer"

(Get-Content tccd.au3 -Raw).replace($From, $To)  | Set-Content tccd.au3.tmp

Start-Process -NoNewWindow -Wait c:\My\Run\AutoIt\Aut2Exe\Aut2exe.exe `
    -ArgumentList '/in tccd.au3.tmp /out tccd.exe /unicode /console /productname tccd /companyname jackhab /filedescription "Directory switcher for external console and Total Commander"'

Remove-Item tccd.au3.tmp