#This script was made for the final exam in Commandline 120 at SPSCC, however I went back to it to improve it after class was over

write-host "1. Display ports."
write-host "2. Sort files in home directory"
write-host "3. Install Windows Subsystem For Linux"
write-host "4. Exit this script"

$a=0
do {
    $a = read-host "Choose a number between 1 and 4"
    switch ($a){
        1{
            #Port Audit
            $typeport = Read-Host "How would you like to sort the ports? Choose a number: `n 
            1. Numerically `n 
            2. Search for range `n
            3. By process `n
            4. listening vs loopback `n
            Your option: " 
            switch($typeport){
                1{
                    #Display all ports by port number
                    Get-NetTCPConnection | Sort-Object LocalPort
                }
                2{
                    #Display a range of port numbers provided by the user
                    $portone = Read-Host "What will be the lower port?"
                    $porttwo = Read-Host "What will be the upper port?"
                    Get-NetTCPConnection | Where-Object {($_.LocalPort -ge $portone) -and ($_.LocalPort -le $porttwo)}
                }
                3{
                    #Search for a port by the process ID
                    $procfind = Read-Host "What process are you looking for?"
                    Get-NetTCPConnection | where-object {($_.process -eq $procfind)}
                }
                4{
                    #Search for ports on the basis of the address
                    $listloop = Read-Host "Sort via 1. listening or 2. loopback? Choose a number."
                    while ($listloop -eq 1 -or 2){
                    if($listloop -eq 1){
                        #Sort by listening
                        Get-NetTCPConnection | Where-Object {($_.RemoteAddress -eq 0.0.0.0)}
                    }elseif ($listloop -eq 2) {
                        #Sort by loopback
                        Get-NetTCPConnection | Where-Object {($_.RemoteAddress -eq 127.0.0.1)}
                    }else{
                        Write-Host "Try again please!"
                        return 
                    }
                    }
                }default{"Can't do that!"}
            }
            
        }
        2{
            #File Sorting
            $location = $(Env:\%HOMEPATH%)
            Set-Location $location
            write-host "You're location has been set to $location"
            #Set location to home directory
            Write-Host "This may error out. However, THIS DID SET THE LOCATION PROPERLY, so continue on."
            $filetype = read-host "What filetype would you like to select? In .png, .exe, etc format. Only use filetypes with a 3 character extension."
            #Select a filetype, filetypes with 4+ character extentions like .docx and .blend are not supported
            while($filetype -like ".???" ){
                $folder = Read-Host "Would you like to make a folder for this? 1. if yes 2. if no."
                #Option to create a folder or not for placing files.
                while($folder -eq 1 -or 2){
                    if($folder -eq 1){
                        #Creating a folder and placing files in it
                        $newfolder = Read-Host "What will be the new folder?"
                        New-Item $newfolder -ItemType Directory
                        $path1 = Get-Location
                        Move-Item *$filetype $path1\$newfolder
                        write-host "Your files have been sorted."
                        return
                    }elseif ($folder -eq 2) {
                        #Identifying a folder and placing files in it
                        $path = Read-Host "What is the path of the folder? Be sure to have permissions..."
                        $confirm = read-host "Your $filetype files will be directed to $path. Are you sure? Y/N"
                        if($confirm -eq "Y" -or "y"){
                            move-item *$filetype $path
                            Write-Host "Your files have been sorted."
                            return
                        }else{
                            return
                        }
                         
                    }
                }

            } 
        }
        3{
            #WSL installation 
        Write-Host "If you have not ran this as an administrator, please quit and do this as an admin."
        $confirmwsl = Read-Host "Would you like to enable Windows Subsystem for Linux? Y or N."
        while ($confirmwsl -eq "Y" -or "y"){
              
            write-Host "What distro would you like? Your options are: "
            wsl.exe -l -o
            #List WSL distros in the Windows Store
            $distrochoose = read-host "Please choose an option, and be exact: "
            wsl.exe --install 
            wsl.exe --update
            wsl.exe -install $distrochoose
            $distrochoose
            #Open chosen distro
                

                
            
        
        }
    }
    }4
    #Close the script
    {Exit}

} until ($a -ne 0..4)