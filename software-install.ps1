# Instalador automatizado de software con Winget para Windows 11

$apps = @(
    @{ name = "Spotify.Spotify";                    display = "Spotify" },
    @{ name = "WhatsApp.WhatsApp";                  display = "WhatsApp" },
    @{ name = "Google.Chrome";                      display = "Google Chrome" },
    @{ name = "Microsoft.VisualStudioCode";         display = "Visual Studio Code" },
    @{ name = "Zoom.Zoom";                          display = "Zoom Workplace" },
    @{ name = "Discord.Discord";                    display = "Discord" },
    @{ name = "AdvancedMicroDevices.AMDSoftware";   display = "AMD Adrenalin Software" },
    @{ name = "Blizzard.BattleNet";                 display = "Battle.net" },
    @{ name = "VideoLAN.VLC";                       display = "VLC Media Player" },
    @{ name = "7zip.7zip";                          display = "7-Zip" },
    @{ name = "Adobe.Acrobat.Reader.64-bit";        display = "Adobe Acrobat Reader" }
)

foreach ($app in $apps) {
    Write-Host "Instalando $($app.display)..."
    winget install --id $($app.name) --accept-source-agreements --accept-package-agreements -h
}
