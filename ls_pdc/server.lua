local connected = {}
local count = {}
local isConnected = false 

RegisterNetEvent('ls_pdc:loaded', function()
    print('loaded')
    local steamid  = GetPlayerIdentifiers(source)[1]
    local license  = GetPlayerIdentifiers(source)[2]
    local xbl      = GetPlayerIdentifiers(source)[3]
    local liveid   = GetPlayerIdentifiers(source)[4]
    local discord  = GetPlayerIdentifiers(source)[5]
    local ip       = GetPlayerIdentifiers(source)[6]

    if not connected[license] then 
        connected[license] = {
            steamid  = steamid,
            license  = license,
            discord  = discord,
            xbl      = xbl,
            liveid   = liveid,
            ip       = ip,
            playerId = source
        }
        print(GetPlayerName(source)..' [ID '..source..'] added to connected-table')
    else
        DropPlayer(source, 'An error occurred [Code: Identifier already exists]. For further information please contact the server support.')
    end
    print(json.encode(connected, {indent=true}))
end)

-- RegisterCommand('check', function(source, cb)
--     local license  = GetPlayerIdentifiers(source)[2]
--     SendToDiscord('**Infos zu Spieler '..GetPlayerName(source)..'[ID '..source..']**', {
--         {name = '**DB-Identifier**', value = string.sub(connected[license].license, 9),  inline = false},
--         {name = '**STEAM-ID**',      value = connected[license].steamid,                 inline = false},
--         {name = '**ROCKSTAR-ID**',   value = connected[license].license,                 inline = false},
--         {name = '**DISCORD-ID**',    value = connected[license].discord,                 inline = false},
--         {name = '**XBOX-ID**',       value = connected[license].xbl,                     inline = false},
--         {name = '**LIVE-ID**',       value = connected[license].liveid,                  inline = false},
--         {name = '**FIVEM-IP**',      value = connected[license].ip,                      inline = false},
--         {name = '**SERVER-ID**',     value = connected[license].playerId,                inline = false},
--     })
--     print('Infos zu Spieler '..GetPlayerName(source)..'[ID '..source..']:'..json.encode(infos, {indent = true}))  
-- end)

AddEventHandler('playerDropped', function(reason)
    local license  = GetPlayerIdentifiers(source)[2]
    print('dropped')
    
    if connected[license] then 
        if connected[license].playerId == source then   
            SendToDiscord('**Infos to player '..GetPlayerName(source)..'[ID '..source..']:**', {
                {name = '**DB-Identifier:**', value = string.sub(connected[license].license, 9),  inline = false},
                {name = '**STEAM-ID:**',      value = connected[license].steamid,                 inline = false},
                {name = '**ROCKSTAR-ID:**',   value = connected[license].license,                 inline = false},
                {name = '**DISCORD-ID:**',    value = connected[license].discord,                 inline = false},
                {name = '**XBOX-ID:**',       value = connected[license].xbl,                     inline = false},
                {name = '**LIVE-ID:**',       value = connected[license].liveid,                  inline = false},
                {name = '**FIVEM-IP:**',      value = connected[license].ip,                      inline = false},
                {name = '**SERVER-ID:**',     value = connected[license].playerId,                inline = false},
            })
            print('Infos to player '..GetPlayerName(source)..'[ID '..source..']:'..json.encode(infos, {indent = true}))    
            connected[license] = nil
            print(GetPlayerName(source)..' [ID '..source..'] deleted from connected-table')
        else 
            print(GetPlayerName(source)..' [ID '..source..'] couldn\'t be found in connected-table')
        end
    end
end)

function SendToDiscord(title, fields)
    local message = {
        username = 'LifeScripts Prevent Double Connect', 
        embeds = {{
            color = webhook['Color'], 
            title = title,
            fields = fields,
            footer = {
                text = 'DATE • '..os.date('%x %X %p'),
                icon_url = webhook['Icon URL'],
            },
        }}, 
        avatar_url = webhook['Avatar URL'] -- Bot Profile Pic
    }
    PerformHttpRequest(webhook['Webhook Link'], function(err, text, headers) end, 'POST', json.encode(message), {['Content-Type'] = 'application/json'})
end
