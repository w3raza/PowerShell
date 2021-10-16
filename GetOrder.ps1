Function Get-Order3 {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 1,
            HelpMessage = "How many cups would you like to purchase?"
        )]
        [int]$cups,

        [Parameter(
            Mandatory = $true,
            Position = 2,
            HelpMessage = "What would you like to purchase?"
        )] 
        [ValidateSet("Lemonade", "Water", "Tea", "Coffee", "Hard Lemonade")]
        [string]$product = "Lemonade"
    )
    DynamicParam {
        if ($product -eq "Hard Lemonade") {
            $ageAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ageAttribute.Position = 3
            $ageAttribute.Mandatory = $true
            $ageAttribute.HelpMessage = "Please enter your age:"
                
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($ageAttribute)
            $ageParam = New-Object System.Management.Automation.RuntimeDefinedParameter ( 'age', [ Int16 ], $attributeCollection)
            $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add( 'age' , $ageParam )

            return $ParamDictionary
        }
    }
    Begin {
        if ($PSBoundParameters.age -and $PSBoundParameters.age -lt 21) {
            Write-Error -ErrorAction Stop "You are not old enough for Hard Lemonade. How about a nice glass of regular Lemonade instead?" 
        } ############ koniec instrukcji 'if'
    } ############ koniec bloku Begin {}

    Process {
        $order = @()
        for ($cup = 1; $cup -le $cups; $cup++) {
            $order += "$($cup): A cup of $($product)"
        }
        $order
    }  
}