local MFD = MF_DnaTracker

function MFD:Awake(...)
  while not ESX do Citizen.Wait(0); end
      self.dS = true
      self:DSP(true);
      MFD.cS = true
     end
  end)
end

function MFD:DoLogin(src)  

end

function MFD:DSP(val) self.cS = val; end

Citizen.CreateThread(function(...) MFD:Awake(...); end)

RegisterNetEvent('MF_DnaTracker:PlaceEvidenceS')
AddEventHandler('MF_DnaTracker:PlaceEvidenceS', function(pos, obj, weapon, weaponType) 
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local playername = ''
  local data = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
  for key,val in pairs(data) do
    playername = val.firstname .. " " .. val.lastname
  end
  TriggerClientEvent('MF_DnaTracker:PlaceEvidenceC', -1, pos, obj, playername, weapon, weaponType)
end)

ESX.RegisterServerCallback('MF_DnaTracker:PickupEvidenceS', function(source, cb, evidence)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local cbData
  if evidence.obj == MFD.BloodObject then
    local count = xPlayer.getInventoryItem('bloodsample')
    if count and count.count and count.count > 0 then cbData = false
    else
      xPlayer.addInventoryItem('bloodsample', 1)
      TriggerClientEvent('MF_DnaTracker:PickupEvidenceC', -1, evidence)
      cbData = true
    end
  elseif evidence.obj == MFD.ResidueObject then
    local count = xPlayer.getInventoryItem('bulletsample')
    if count and count.count and count.count > 0 then cbData = false
    else
      xPlayer.addInventoryItem('bulletsample', 1)
      TriggerClientEvent('MF_DnaTracker:PickupEvidenceC', -1, evidence)
      cbData = true
    end
  end
  cb(cbData)
end)

ESX.RegisterServerCallback('MF_DnaTracker:GetJob', function(source, cb, evidence)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local cbData = xPlayer.job.name
  cb(cbData)
end)

ESX.RegisterUsableItem('dnaanalyzer', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('bloodsample').count > 0 then 
    xPlayer.removeInventoryItem('bloodsample', 1)
    TriggerClientEvent('MF_DnaTracker:AnalyzeDNA', source)
  end
end)

ESX.RegisterUsableItem('ammoanalyzer', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('bulletsample').count > 0 then 
    xPlayer.removeInventoryItem('bulletsample', 1)
    TriggerClientEvent('MF_DnaTracker:AnalyzeAmmo', source)
  end
end)

ESX.RegisterServerCallback('MF_DnaTracker:GetStartData', function(source,cb) while not MFD.dS do Citizen.Wait(0); end; cb(MFD.cS); end)
