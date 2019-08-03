<#
.SYNOPSIS 
Use this script to convert a soft deleted mailbox to a shared mailbox in Exchange online.
 
.DESCRIPTION  
This script perform below steps:
1. Save the soft deleted mailbox in a variable
2. Create a new Shared Mailbox
3. Change the Max Receive Size to 150 MB
4. Restore emails from soft deleted mailbox to newly created shared mailbox
5. Hide the Mailbox in GAL
6. Grant Line Manager full access on new shared mailbox
7. Check the Mailbox Restore Request status

.OUTPUTS 
Results are printed to the console.
 
.NOTES 
Written by: Aws Ayad

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS
CODE REMAINS WITH THE USER.
#>

write-host 
write-host +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
write-host   'Starting the process of restoring a soft-deleted account to a shared mailbox in Exchange online' -ForegroundColor yellow -BackgroundColor DarkGreen
write-host +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
write-host

try 
    {
   
    $SoftDeletedMailbox = Read-Host "Please enter the soft deleted mailbox email address"
    write-host "***********************************************************************************************************************************"
    $SharedMailboxDisplayName = Read-Host "Please enter the shared mailbox display name (i.e RFT123456 - John smith)"
    write-host "***********************************************************************************************************************************"
    $SharedMailboxPrimarySmtpAddress = Read-Host "Please enter the shared mailbox Primary SMTP address (i.e. RFT123456_DD-MM-YYYY@Huntsman.com)"
    write-host "***********************************************************************************************************************************"
    $LineManager = Read-Host "Please enter the user's line manager to be granted a full access permission on the shared mailbox"
    write-host "***********************************************************************************************************************************"

    Write-Host "Step1: saving the soft deleted mailbox in a variable"
    $InActive = Get-Mailbox -SoftDeletedMailbox -Identity $SoftDeletedMailbox
    write-host "***********************************************************************************************************************************"

    Write-Host "Step2: Creating the Shared Mailbox"
    New-Mailbox -Shared -Name $SharedMailboxDisplayName -DisplayName $SharedMailboxDisplayName -PrimarySmtpAddress $SharedMailboxPrimarySmtpAddress
    write-host "***********************************************************************************************************************************"

    Write-Host "Step3: Changing the Max Receive Size to 150 MB"
    Get-Mailbox $SharedMailboxDisplayName | Set-Mailbox -MaxReceiveSize 150MB
    write-host "***********************************************************************************************************************************"

    Write-Host "Step4: Restoring emails from the soft-deleted mailbox to the newly created shared mailbox"
    New-MailboxRestoreRequest -Name $SharedMailboxDisplayName -SourceMailbox $InActive.DistinguishedName -TargetMailbox $SharedMailboxPrimarySmtpAddress -AllowLegacyDNMismatch
    write-host "***********************************************************************************************************************************"

    Write-Host "Step5: Hiding the shared mailbox in GAL"
    Set-Mailbox $SharedMailboxPrimarySmtpAddress -HiddenFromAddressListsEnabled $true
    write-host "***********************************************************************************************************************************"

    Write-Host "Step6: Grant Line Manager full access on the shared mailbox"
    Add-MailboxPermission -Identity $SharedMailboxPrimarySmtpAddress -User $LineManager -AccessRights fullaccess
    write-host "***********************************************************************************************************************************"

    Write-Host "Step7: Checking the Mailbox Restore Request status"
    Get-MailboxRestoreRequestStatistics -Identity $SharedMailboxDisplayName | Format-List perc*
    write-host "***********************************************************************************************************************************"

    }

finally
    {
    write-host "*****************************************************************************************************"
    write-host "Done, script completed successfully" -ForegroundColor white -BackgroundColor Red
    write-host "*****************************************************************************************************"
    write-host "The soft deleted mailbox successfully restored/converted to a shared mailbox" -ForegroundColor white -BackgroundColor Red
    write-host "*****************************************************************************************************"
    write-host "`n" 
    }