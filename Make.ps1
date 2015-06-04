﻿# Build.ps1
#
# Collects VBEX files into an office add-in file
#
# Copywrite (C) 2015 Philip Wales
#
Param(
    [ValidateSet("Excel")]
        [String]$officeApp = "Excel"
)

# locations of required libraries change according to OS arch.
# Our libs are 32 bit.
$programFiles = if ([Environment]::Is64BitOperatingSystem) { 
	"Program Files (x86)"
} else { 
	"Program Files"
}

# constants are illegible in powershell
$VBA_EXTENSIBILITY_LIB = "C:\$programFiles\Common Files\Microsoft Shared\VBA\VBA6\VBE6EXT.OLB"
$VBA_SCRIPTING_LIB = "C:\Windows\system32\scrrun.dll"
$buildScript = (Join-Path $PSScriptRoot "Build.ps1")

$buildRefs = @{
    "src" = @("$VBA_EXTENSIBILITY_LIB", "$VBA_SCRIPTING_LIB");
    "test" = @()
}

ForEach ($build In $buildRefs.Keys) {
    $path = (Join-Path $PSScriptRoot "VBEX$build.xlam")
    $files = (Get-ChildItem (Join-Path $PSScriptRoot $build)).FullName
    $refs = $buildRefs[$build]
    & "$buildScript" "$path" $files $refs
}

Write-Host "VBEXtest must reference VBEXsrc and Rubberduck if prior to v1.3"