Write-Host ""
Write-Host "What option do you want to choose?"
Write-Host "1. Collect new Baseline?"
Write-Host "2. Compare Baseline?"
Write-Host ""
$option = Read-Host "Enter 1 or 2"
Write-Host ""

Function Calc-Hash($filepath){
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}
Function Erase-Baseline{
    $baselineExist= Test-Path -Path "C:\Users\brian\source\repos\File integrity Monitoring Home Lab\File integrity Monitoring Home Lab\baseline.txt"
    if ($baselineExist -eq $true){
		Remove-Item -Path "C:\Users\brian\source\repos\File integrity Monitoring Home Lab\File integrity Monitoring Home Lab\baseline.txt"
	}
}
if ($option -eq 1){
    Erase-Baseline
    Write-Host "Creating new hashes into baseline.txt" -ForegroundColor DarkGreen
    $files = Get-ChildItem -Path "C:\Users\brian\source\repos\File integrity Monitoring Home Lab\File integrity Monitoring Home Lab\Files\" 
    foreach ($file in $files){
		$hash = Calc-Hash $file.FullName
		"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath "C:\Users\brian\source\repos\File integrity Monitoring Home Lab\File integrity Monitoring Home Lab\baseline.txt" -Append
       }
}
elseif ($option -eq 2){
    $fileHashPaths = Get-Content -Path "C:\Users\brian\source\repos\File integrity Monitoring Home Lab\File integrity Monitoring Home Lab\baseline.txt"
    $hashDictionary = @{}
    foreach ($file in $fileHashPaths){
		$hashDictionary.add($file.Split("|")[0],$file.Split("|")[1])
	}

    while ($true){
        Write-Host "Monitoring hashes to baseline.txt..." -ForegroundColor Cyan
        Start-Sleep -Seconds 2
        $files = Get-ChildItem -Path "C:\Users\brian\source\repos\File integrity Monitoring Home Lab\File integrity Monitoring Home Lab\Files\" 
        foreach ($file in $files){
		    $hash = Calc-Hash $file.FullName
            if($HashDictionary[$hash.Path] -eq $null){
                Write-Host "New file detected: $($hash.Path)" -ForegroundColor Green
            }
            elseif($HashDictionary[$hash.Path] -ne $hash.Hash){
                Write-Host "$($hash.Path) has changed!" -ForegroundColor Red
            }
       }
       foreach ($key in $HashDictionary.Keys){
            $baselineFileExists = Test-Path -Path $key
            if ($baselineFileExists -eq $false){
			    Write-Host "File deleted: $key" -ForegroundColor Red
			}
        }


    }
  }
