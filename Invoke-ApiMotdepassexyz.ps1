Function Invoke-ApiMotdepassexyz {
<#
  .SYNOPSIS
    Invoke API of motdepasse.xyz website to randomly generate passwords.

  .DESCRIPTION
    Customize the URI API depending on which password policy you wish to use.
    Let you choose between lowercases only, include digits caracters, include uppercases and special characters.

  .PARAMETER Length
    Mandatory. Specifies the length of the password; Should be between 4 and 512 characters.

  .PARAMETER Quantity
  Optional. Specifies the number of paswoords to generate. 1 by default.

  .PARAMETER Digits
  Optional. Specifies the number of Digits the password should have. No Digits by default.

  .PARAMETER Uppercase
  Optional. Specifies the number of Uppercases the password should have. No Uppercases by default.

  .PARAMETER SpecialCharacters
    Optional. Specifies the number of Special characters the password should have. No Non-Alphanumeric characters by default.

  .INPUTS
    Parameters above

  .OUTPUTS
    Array of randomly generated passwords.

  .NOTES
    Version: 1.0
    Author: Thibault Baheux
    Creation Date: 17.05.2021
    Purpose/Change: Initial function development.

  .LINK

  .EXAMPLE
    Invoke-ApiMotdepassexyz -Length 15
    Generates 1 random password of 15 characters, containing only lowercases.
  
    Invoke-ApiMotdepassexyz -Length 40 -Quantity 5 -Digits -Uppercase -SpecialCharacters
    Generates 5 random passwords of 40 characters each, containing lowercases, digits, uppercases and special non-alphanumeric characters.
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][int]$Length,
        [Parameter(Mandatory=$false)][int]$Quantity=1,
        [Parameter(Mandatory=$false)][switch]$Digits,
        [Parameter(Mandatory=$false)][switch]$Uppercase,
        [Parameter(Mandatory=$false)][switch]$SpecialCharacters
    )
    Begin {
        #Building Uri
        if (!(($Length -ge 4) -and ($Length -le 512))) {
            Write-Error "Password length should be between 4 and 512 characters"
            break
        }
        if (!(($Quantity -ge 1) -and ($Quantity -le 30))) {
            Write-Error "Quantity should be between 1 and 30 passwords to generate."
            break
        }
        $Uri = "https://api.motdepasse.xyz/create/?include_lowercase&password_length=$Length&quantity=$Quantity"
            if ($Digits) {
                $Uri += "&include_digits"
            }
            if ($Uppercase) {
                $Uri += "&include_uppercase"
            }
            if ($SpecialCharacters) {
                $Uri += "&include_special_characters"
            }
        $Passwords = @()
    }
    Process {
        Try {
            $ApiResult = Invoke-RestMethod -Uri $Uri
        }
        Catch {
            Write-Outut $_.Exception
            Break
        }
    }
    End {
        For($i=0;$i -lt $Length;$i++) {
            $Passwords += $ApiResult.passwords[$i]
        }
        Return $Passwords
    }
}