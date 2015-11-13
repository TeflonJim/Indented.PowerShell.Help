function UpdateHelpExample {
  # .EXTERNALHELP Indented.PowerShell.Help-Help.xml

  [CmdletBinding()]
  [OutputType([System.Xml.Linq.XDocument])]
  param(
    $Example,

    [Parameter(Mandatory = $true)]
    [System.Management.Automation.CommandInfo]$CommandInfo,

    [Parameter(Mandatory = $true)]
    [System.Xml.Linq.XDocument]$XDocument,

    [Switch]$Append
  )

  Write-Host "Hello"
  
  return $XDocument
}