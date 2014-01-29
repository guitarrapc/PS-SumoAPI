#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Get-PSSumoLogicApiCollectorSource
{
    [CmdletBinding(
    )]
    param(
        # Input CollectorId
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $CollectorId,

        # Input Source Id
        [parameter(
            position = 1,
            mandatory = 0)]
        [int[]]
        $Id = $null,

        [parameter(
            position = 2,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-SumoLogicApiCredential),

        [parameter(
            position = 3,
            mandatory = 0)]
        [switch]
        $Async
    )

    begin
    {
        $ErrorActionPreference = $PSSumoLogicApi.errorPreference
    }

    process
    {
        try
        {
            if ($PSBoundParameters.Async.IsPresent)
            {
                Write-Verbose "Running Async execution"
                if ($null -eq $SourceId)
                {
                    $command = {
                        param
                        (
                            [int]$Collector,
                            [hashtable]$PSSumoLogicApi,
                            [System.Management.Automation.PSCredential]$Credential,
                            [string]$verbose
                        )

                        $VerbosePreference = $verbose
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
                        Write-Verbose -Message ("Sending Asynchronous Get Collector Source Request '{0}'" -f $uri)
                        Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -ContentType $PSSumoLogicApi.contentType -Credential $Credential
                    }
                                
                    Invoke-PSSumoLogicApiInvokeCollectorAsync -Command $command -CollectorId $CollectorId -credential $Credential
                }
                else
                {
                    $command = {
                        param
                        (
                            [int]$Collector,
                            [int]$Source,
                            [hashtable]$PSSumoLogicApi,
                            [System.Management.Automation.PSCredential]$Credential,
                            [string]$verbose
                        )

                        $VerbosePreference = $verbose
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
                        Write-Verbose -Message ("Sending Asynchronous Get Collector Source Request '{0}'" -f $uri)
                        Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -ContentType $PSSumoLogicApi.contentType -Credential $Credential
                    }
                    Invoke-PSSumoLogicApiInvokeCollectorSourceAsync -Command $command -CollectorId $CollectorId -SourceId $Id -credential $Credential
                }
            }
            else
            {
                foreach ($Collector in $CollectorId)
                {
                    if ($null -eq $Id)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
                        Write-Verbose -Message ("Sending Synchronous Get Collector Source Request '{0}'" -f $uri)
                        (Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -ContentType $PSSumoLogicApi.contentType -Credential $Credential).sources                    
                    }
                    else
                    {
                        foreach ($Source in $Id)
                        {
                            [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
                            Write-Verbose -Message ("Sending Synchronous Get Collector Source Request '{0}'" -f $uri)
                            (Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -ContentType $PSSumoLogicApi.contentType -Credential $Credential).source
                        }
                    }
                }
            }
        }
        catch
        {
            throw $_
        }
    }
}
