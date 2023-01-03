# To use this script, save this file as Set-webcams-state.ps1 and execute the following command line:
# 
# .\Set-webcams-state.ps1 disable 


#Disable webcams from a computer
function Toggle-Webcams {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Disable', 'Enable')]
    [String]$Action
  )

  $webcams = Get-WmiObject -Class "Win32_PnPEntity" | Where-Object {$_.Name -like "*webcam*"}

  if ($webcams) {
    # Itérer sur chaque caméra et exécuter l'action spécifiée
    foreach ($webcam in $webcams) {
      $device = Get-WmiObject -Class "Win32_PNPEntity" -Filter "Name='$($webcam.Name)'"
      if ($Action -eq 'Disable') {
        $device.Disable()
        Write-Output "Webcam $($webcam.Name) Disabled"
      }
      else {
        $device.Enable()
        Write-Output "Webcam $($webcam.Name) Enabled"
      }
    }
  }
  else {
    Write-Output "No webcam found"
  }
}

# Lire les options de ligne de commande
$Action = $args[0]

# Appeler la fonction Toggle-Webcams en passant l'action spécifiée en tant qu'argument
Toggle-Webcams -Action $Action
