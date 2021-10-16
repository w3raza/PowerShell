function Travel {
    param
    (
        [Parameter(
            Mandatory = $true,
            Position = 1,
            HelpMessage = "Where do you want to travel?",
            ParameterSetName = "Trip"
        )]
        [string] $country,
        [Parameter(
            Mandatory = $true,
            Position = 2,
            HelpMessage = "How many places would you like to book?"
        )]
        [int]$people,
        [Parameter(
            Mandatory = $true,
            Position = 3,
            HelpMessage = "Enter your email to book",
            ParameterSetName = "Trip"
        )]
        [ValidatePattern("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")]
        [string] $email,
        [Parameter(
            Mandatory = $false,
            Position = 4,
            HelpMessage = "Do you have a discount?",
            ParameterSetName = "Trip"
        )]
        [ValidateSet("normal", "discount")]
        [string]$kind = "normal"
    )
    

    DynamicParam {
        if ($kind -eq "discount") {
            $CodeAttribute = New-Object System.Management.Automation.ParameterAttribute
            $CodeAttribute.Position = 5
            $CodeAttribute.Mandatory = $true
            $CodeAttribute.HelpMessage = "Please give us your discount code and expiration date"

            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

            $attributeCollection.Add($CodeAttribute)

            $CodeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Code', [string], $attributeCollection)
            $paramsDict = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramsDict.Add('Code', $CodeParam)
            return $paramsDict
        }
    }

    Begin {
        if ($PSBoundParameters.Code) {
            if ($PSBoundParameters.Code -eq "") {
                Write-Error -ErrorAction Stop "Please give us your discount code and expiration date"
            }
            $array = $PSBoundParameters.Code
            $Code = -split $array


            if ($Code.length -ne 2) {
                Write-Error -ErrorAction Stop "You forgot about sth"
            }

            if ($Code[0] -ne 1234) {
                Write-Error -ErrorAction Stop "Wrong discount code"
            }

            if ($Code[1] -notmatch "[0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]") {
                Write-Error -ErrorAction Stop "Wrong date"
            }
        }
    }

    Process {
        $countries = @{
            Poland   = @{price = 1599; places = 6 };
            France   = @{price = 3299; places = 1 };
            Germany  = @{price = 2199; places = 0 };
            Belarus  = @{price = 2899; places = 4 };
            Hungary  = @{price = 1299; places = 2 };
            Latvia   = @{price = 2599; places = 5 };
            Slovakia = @{price = 999; places = 2 };
            Greece   = @{price = 4799; places = 2 }
        }
        
        if (!$countries.ContainsKey($country)) {
            Write-Host "We are so sorry, we do not have any offers: " $country;

            Write-Host "Here's what we offer:"
            foreach ($n in $countries.GetEnumerator()) {
                Write-Host $n.Name": " $n.Value.price "zl"
            }
            return
        }

        if ($people -gt $countries.($country).places) {
            Write-Host "I'm afraCode we're booked up this number od places for:" $country;

            Write-Host "Here's what we offer, price for this and number of places"
            foreach ($n in $countries.GetEnumerator()) {
                Write-Host $n.Name": " $n.Value.price "zl: " $n.Value.places 
            }
            return
        }

        

        Write-Host "Booking details: "
        Write-Host -BackgroundColor Black -ForegroundColor White "Email: " $email
        Write-Host -BackgroundColor Black -ForegroundColor White "Country: " $country
        if ($kind -eq "normal") {
            $total = $people * $countries.($country).price
            if ($people -gt 1) {
                Write-Host -BackgroundColor Black -ForegroundColor White "Total price for $($people) people: $($total) zl"
            }
            else {
                Write-Host -BackgroundColor Black -ForegroundColor White "Total price for $($people) person: $($total) zl"
            }
            Write-Host "Kind ticket: " $kind
            
        }
        else {
            Write-Host "Kind ticket: discount"

        
            [double]$total = 0.8 * $people * $countries.($country).price
            if ($people -gt 1) {
                Write-Host -BackgroundColor Black -ForegroundColor White "Total price for $($people) people: $($total) zl"
            }
            else {
                Write-Host -BackgroundColor Black -ForegroundColor White "Total price for $($people) person: $($total) zl"
            }
        }
    }
}