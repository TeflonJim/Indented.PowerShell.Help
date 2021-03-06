function AddXElement {
  # .SYNOPSIS
  #   Add an XElement into an existing XContainer.
  # .DESCRIPTION
  #   Internal use only.
  #
  #   AddXElement adds items to a document in alphabetical order.
  # .PARAMETER Comment
  #   Add an XML comment prior to the new XElement.
  # .PARAMETER Parent
  #   The parent element which is expected to contain the XElement.
  # .PARAMETER SortBy
  #   SortBy expects an XPath Expression which will resolve the ID in both the new XElement and the supplied XDocument.
  # .PARAMETER XContainer
  #   The XElement will be added to the parent described by XContainer.
  # .PARAMETER XElement
  #   The new element to add.
  # .INPUTS
  #   System.String
  #   System.Xml.Linq.XElement
  #   System.Xml.Linq.XDocument
  # .NOTES
  #   Author: Chris Dent
  #
  #   Change log:
  #     11/11/2015 - Chris Dent - Added error handler to kill the pipeline if the expected parent path does not exist for some reason (mal-formed document).
  #     03/11/2015 - Chris Dent - Created.
 
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [System.Xml.Linq.XElement]$XElement,
    
    [Parameter(Mandatory = $true)]
    [System.Xml.Linq.XContainer]$XContainer,
    
    [Parameter(Mandatory = $true)]
    [String]$Parent,
    
    [String]$SortBy,
    
    [String]$Comment
  )

  process {
    $PrecedingXElement = $null
	  if ($psboundparameters.ContainsKey('SortBy')) {
		  $NewElementID = SelectXPathXElement -XPathExpression $SortBy -XContainer $XElement | Select-Object -ExpandProperty Value
		  
		  $PrecedingXElement = $null
		  SelectXPathXElement -XPathExpression "$Parent/*" -XContainer $XContainer |
		    ForEach-Object {
		      $ElementID = SelectXPathXElement -XPathExpression $SortBy -XContainer $_ | Select-Object -ExpandProperty Value
		      if ($ElementID -lt $NewElementID) {
		        $PrecedingXElement = $_
		      }
		    }
		}
	  
	  if ($psboundparameters.ContainsKey('Comment')) {
	    $NewXElement = [Array]([System.Xml.Linq.XComment](New-Object System.Xml.Linq.XComment $Comment)) + $XElement
	  } else {
	    $NewXElement = $XElement 
	  }
	  
	  if ($PrecedingXElement) {
	    $PrecedingXElement.AddAfterSelf($NewXElement)
	  } else {
	  	$ParentXElement = SelectXPathXElement -XPathExpression $Parent -XContainer $XContainer
	  	if ($ParentXElement) {
  	  	if ($psboundparameters.ContainsKey('SortBy')) {
  	  		$ParentXElement.AddFirst($NewXElement)
  	  	} else {
  	  		$ParentXElement.Add($NewXElement)
  	  	}
  	  } else {
       $pscmdlet.ThrowTerminatingError((
          New-Object System.Management.Automation.ErrorRecord(
            (New-Object System.InvalidOperationException "The expected parent node does not exist."),
            'ParentXNodeValidation,Indented.PowerShell.Help.AddXElement',
            'OperationStopped',
            $Parent
          )
        ))
  	  }
	  }
	}
}