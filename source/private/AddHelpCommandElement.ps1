function AddHelpCommandElement {
  # .SYNOPSIS
  #   Add a template to an XDocument for a command.
  # .DESCRIPTION
  #   Internal use only.
  #
  #   Add-HelpCommand may be used to create all expected XML elements associated with the description of a command.
  # .PARAMETER CommandInfo
  #   The command to add.
  # .PARAMETER XDocument
  #   The document to modify.
  # .INPUTS
  #   System.Management.Automation.CommandInfo
  #   System.String
  #   System.Xml.Linq.XDocument
  # .OUTPUTS
  #   System.Xml.Linq.XDocument
  # .EXAMPLE
  #   Add-HelpCommand (Get-Command Get-Process)
  # .NOTES
  #   Author: Chris Dent
  #
  #   Change log:
  #     29/10/2015 - Chris Dent - Created.

  [CmdletBinding()]
  [OutputType([System.Xml.Linq.XDocument])]
  param(
    [Parameter(Mandatory = $true, Position = 1)]
    [System.Management.Automation.CommandInfo]$CommandInfo,

    [Parameter(Mandatory = $true)]
    [System.Xml.Linq.XDocument]$XDocument
  )

  $XElement = SelectXPathXElement `
    -XPathExpression "/helpItems/command:command[command:details/command:name='$($CommandInfo.Name)']" `
    -XContainer $XDocument
  if (-not $XElement) {
    Write-Verbose "  Creating command element"

    $XElement = GetTemplateXElement 'command:command'
    $XElement.Element((GetXNamespace 'command') + 'details').`
              Element((GetXNamespace 'command') + 'name').`
              Value = $CommandInfo.Name
      
    $XElement.Element((GetXNamespace 'command') + 'details').`
              Element((GetXNamespace 'command') + 'verb').`
              Value = $CommandInfo.Verb
    
    $XElement.Element((GetXNamespace 'command') + 'details').`
              Element((GetXNamespace 'command') + 'noun').`
              Value = $CommandInfo.Noun
    
    AddXElement -XContainer $XDocument `
      -XElement $XElement `
      -Parent '/helpItems' `
      -SortBy './command:details/command:name' `
      -Comment $($CommandInfo.Name)
  }
}