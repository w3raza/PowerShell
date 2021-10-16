function Podroz {
    param
    (
        [Parameter(
            Mandatory = $true,
            Position = 1,
            HelpMessage = "Gdzie chcesz się udac?",
            ParameterSetName = "Wycieczka"
        )]
        [string] $panstwo,
        [Parameter(
            Mandatory = $true,
            Position = 2,
            HelpMessage = "Ile miejsc chcesz zarezerwowac?"
        )]
        [int]$osoby,
        [Parameter(
            Mandatory = $true,
            Position = 3,
            HelpMessage = "Wpisz swoj email w celu rezerwacji",
            ParameterSetName = "Wycieczka"
        )]
        [ValidatePattern("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")]
        [string] $email,
        [Parameter(
            Mandatory = $false,
            Position = 4,
            HelpMessage = "Posiadasz znizke?",
            ParameterSetName = "Wycieczka"
        )]
        [ValidateSet("normalny", "znizka")]
        [string]$rodzaj = "normalny"
    )
    

    DynamicParam {
        if ($rodzaj -eq "znizka") {
            $AtrybutKodu = New-Object System.Management.Automation.ParameterAttribute
            $AtrybutKodu.Position = 5
            $AtrybutKodu.Mandatory = $true
            $AtrybutKodu.HelpMessage = "Proszę, wpisz kod znizkowy oraz date waznosci"

            $AtrybutKolekcji = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

            $AtrybutKolekcji.Add($AtrybutKodu)

            $ParametrKodu = New-Object System.Management.Automation.RuntimeDefinedParameter('Kod', [string], $AtrybutKolekcji)
            $SlownikParametru = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $SlownikParametru.Add('Kod', $ParametrKodu)
            return $SlownikParametru
        }
    }

    Begin {
        if ($PSBoundParameters.Kod) {
            if ($PSBoundParameters.Kod -eq "") {
                Write-Error -ErrorAction Stop "Wpisz kod znizkowy oraz date waznosci"
            }
            $tablica = $PSBoundParameters.Kod
            $Kod = -split $tablica


            if ($Kod.length -ne 2) {
                Write-Error -ErrorAction Stop "Zapomniales o czyms"
            }

            if ($Kod[0] -ne 1234) {
                Write-Error -ErrorAction Stop "Zly kod"
            }

            if ($Kod[1] -notmatch "[0-9][0-9]-[0-9][0-9]-[0-9][0-9]") {
                Write-Error -ErrorAction Stop "Zly format wprowadzonej daty, poprawny np.23-05-21"
            }
            [string]$date = Get-Date -UFormat %D
            Write-Host $date
            if ($Kod[1] -lt $date) {
                Write-Error -ErrorAction Stop "Kod jest juz nie wazny"
            }
        }
    }

    Process {
        $panstwa = @{
            Polska   = @{cena = 1599; miejsca = 6 };
            Francja  = @{cena = 3299; miejsca = 1 };
            Niemcy   = @{cena = 2199; miejsca = 0 };
            Biolorus = @{cena = 2899; miejsca = 4 };
            Wegry    = @{cena = 1299; miejsca = 2 };
            Litwa    = @{cena = 2599; miejsca = 5 };
            Slowacja = @{cena = 999; miejsca = 2 };
            Grecja   = @{cena = 4799; miejsca = 2 }
        }
        
        if (!$panstwa.ContainsKey($panstwo)) {
            Write-Host "Przepraszamy, ale nie posiadamy w ofercie: " $panstwo;

            Write-Host "Ponizej zalaczam nasza oferte:"
            foreach ($n in $panstwa.GetEnumerator()) {
                Write-Host $n.Name": " $n.Value.cena "zl"
            }
            return
        }

        if ($osoby -gt $panstwa.($panstwo).miejsca) {
            Write-Host "Obawiam sie, ze nie mamy tylu dostepnych miejsc na:" $panstwo;

            Write-Host "Ponizej znajduje sie nasza oferta; cena oraz ilosc dostepnych miejsc"
            foreach ($n in $panstwa.GetEnumerator()) {
                Write-Host $n.Name": " $n.Value.cena "zl: " $n.Value.miejsca 
            }
            return
        }

        Write-Host "Dane rezerwacji: "
        Write-Host "Email: " $email
        Write-Host "Panstwo: " $panstwo
        if ($rodzaj -eq "normalny") {
            $Calkowita = $osoby * $panstwa.($panstwo).cena
            if ($osoby -gt 1) {
                Write-Host -BackgroundColor Black -ForegroundColor White "Calkowita cena za $($osoby) osoby: $($Calkowita) zl"
            }
            else {
                Write-Host -BackgroundColor Black -ForegroundColor White "Calkowita cena za $($osoby) osobe: $($Calkowita) zl"
            }
            
            
        }
        else {        
            [double]$Calkowita = 0.8 * $osoby * $panstwa.($panstwo).cena
            if ($osoby -gt 1) {
                Write-Host -BackgroundColor Black -ForegroundColor White "Calkowita cena za $($osoby) osoby: $($Calkowita) zl"
            }
            else {
                Write-Host -BackgroundColor Black -ForegroundColor White "Calkowita cena za $($osoby) osobe: $($Calkowita) zl"
            }
        }
        Write-Host "rodzaj biletu:" $rodzaj
    }
}