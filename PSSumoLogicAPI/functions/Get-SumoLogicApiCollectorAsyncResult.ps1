#Requires -Version 3.0

# # -- Async cmdlets -- # #

function Get-SumoLogicApiCollectorAsyncResult
{

    [CmdletBinding()]
    param
    (
        [parameter(
            position = 0,
            mandatory = 1)]
        [array]
        $runspaceCollection
    )

    $ErrorActionPreference = "stop"

    # get Async result and end powershell session
    Write-Debug "obtain process result"
    foreach ($runspace in $runspaceCollection)
    {
        # obtain Asynchronos command result
        $private:task = $runspace.powershell.EndInvoke($runspace.Runspace)
            
        $property = ($task | Get-Member -MemberType NoteProperty).Name
            
        # show result
        $task.$property
            
        # Dispose pipeline
        $runspace.powershell.Dispose()
    }
}
