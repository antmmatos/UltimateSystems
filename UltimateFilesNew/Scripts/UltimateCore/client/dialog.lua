local dialogOpen = false
local currDialog = nil
local currFS = {}
local currFC = {}

function CreateDialog(name, label, input, help, submitFunc, cancelFunc, textarea)
    if not dialogOpen then
        currDialog = name
        currFS = submitFunc
        currFC = cancelFunc
        SetNuiFocus(true, true)
        if textarea == nil then
            textarea = false
        end
        SendNUIMessage({
            action = "showDialog",
            menuAction = name,
            label = label,
            defaultInput = input,
            helpText = help,
            textarea = textarea
        })
        dialogOpen = true
    end
end

RegisterNUICallback('exit', function(data)
    SetNuiFocus(false, false)
    if currFC ~= nil then
        currFC()
    end
    currDialog = nil
    currFS = nil
    currFC = nil
    dialogOpen = false
end)

RegisterNUICallback('submit', function(data)
    SetNuiFocus(false, false)
    dialogOpen = false
    if data.currMA == currDialog then
        local doSubmitFunction = currFS
        currDialog = nil
        currFS = nil
        currFC = nil
        doSubmitFunction(data.text)
    end
end)
