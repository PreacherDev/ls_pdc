local alreadySpawned = false

AddEventHandler('esx:onPlayerSpawn', function(spawn)
    print('loaded clientsided')
    if not alreadySpawned then
        alreadySpawned = true 
        TriggerServerEvent('ls_pdc:loaded') 
    end
end)