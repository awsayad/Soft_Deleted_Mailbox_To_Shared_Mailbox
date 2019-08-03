## SYNOPSIS 
Use this script to convert a soft deleted mailbox to a shared mailbox in Exchange online.
 
## DESCRIPTION  
This script perform below steps:
1. Save the soft deleted mailbox in a variable
2. Create a new Shared Mailbox
3. Change the Max Receive Size to 150 MB
4. Restore emails from soft deleted mailbox to newly created shared mailbox
5. Hide the Mailbox in GAL
6. Grant Line Manager full access on new shared mailbox
7. Check the Mailbox Restore Request status

## OUTPUTS 
Results are printed to the console.
 
## NOTES 
Written by: Aws Ayad

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS
CODE REMAINS WITH THE USER.