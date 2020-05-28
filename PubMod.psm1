<#
.SYNOPSIS
    Publish a module to user module directory and optionall to repo.

.DESCRIPTION
    Copies over the current directory (if not otherwise specified) and then prompts whether to publish the module to a repository.
    
.PARAMETER Name
    Optional. The Name of the module. Otherwise uses the name of the parent directory.

.PARAMETER Path
    Optional. The path to the module / folder you want to publish.

.PARAMETER Repo
    Optional. The name of the repository to publish to.

.EXAMPLE
    PubMod # Copies everything in the current directory to the user module directory, prompts to publish

.AUTHOR
    Spencer Stewart, Big Bear Mountain Resort

.DATE
    Created: 2020-4-15
    Last modified: 2020-5-28
#>
function PubMod {
    param (
        [Parameter(Mandatory=$false)]
        [String]
        $Name,
        [Parameter(Mandatory=$false)]
        [String]
        $Path,
        [Parameter(Mandatory=$false)]
        [String]
        $Repo = "LocalPSRepo"
    )

    if (!$Path) {
        $Path = Get-Location | Select-Object -ExpandProperty Path
        Write-Warning "Assuming module to publish is in current directory: $Path"
    }

    if (!$Name) {
        $Name = ($Path -split "\\")[-1]
        Write-Warning "Using name of current directory as module name: $Name"
        Start-Sleep 1
    }

    $UserModuleDirectory = $env:PSModulePath -split ';' | Where {$_ -like '*Users*'} | Select-Object -First 1

    Write-Output "Copying $Path to $UserModuleDirectory"
    Start-Sleep -Milliseconds 500
    Copy-Item $Path $UserModuleDirectory -Recurse -Force

    $Publish = Read-Host "Publish Module to Repo: $Repo [Y | N]"
    if ($Publish -eq "Y") {
        Write-Output "Publishing module to $Repo"
        Start-Sleep -Milliseconds 500
        Publish-Module -Name $Name -Repository $Repo -Verbose
    }
    

}

