ConfigServer = {
    ----- Basic Configuration -----

    Framework = "ESX", -- ESX or QBCORE
    
    ESX = "d4rkac:getSharedObject", -- If using ESX

    TriggersPrefix = "d4rkac:", -- Prefix for the triggers

    Locale = "EN", -- PT or EN by default

    WebhookGeneral = "https://discord.com/api/webhooks/955513869697167360/T0pm67aKzfVAfriF4gwM5ZRHCTQNkr_tIkhsFlwjLdkmFAUt-cUwQSy4na66a--Dtt5z",

    WebhookTriggers = "https://discord.com/api/webhooks/954147495175422003/gntMTFhIQHLkzcvTpBDt3hWb5N9cSwEHsG4I3zBwX1bnSMCZrE_k1PRxPSiIFP8-uU1E",

    WebhookProps = "https://discord.com/api/webhooks/954147671029993583/kOIOBjXFsDLqDVQ8IiJBd0qDzA3OCP1wpKCOO-_nrK3iCHh9J9TmHrG6cW0ulca_bdL8",

    WebhookBans = "https://discord.com/api/webhooks/954151493911592970/shEj4eCuTg0vCtLFCKirR-073n9Mu0K6CX8YihX-Gf1etHEUAO_IBi5NVeq9anfhohWk",

    WebhookScreenshotRequests = "https://discord.com/api/webhooks/955514365665226833/M7zZSuqaFxPbHbEbbMAFhqwyUoEOw3_Uba6sxFyVV9dZRysVhrvdkcqZ1_S84Y1hMXTU",
    
    WebhookLicense = "https://discord.com/api/webhooks/955515027153117234/WfITS1RUsvS-40ZL4rsMqVGHwyqrQWT3z8n3Z9MzAMgbEzvsj3Z2137lmjpoTfHzRt8a",

    RequireSteam = true, -- If the AntiCheat should kick members that don't have Steam open
    
    AcePermission = "D4rkAC", -- Do not touch if you don't know what is it

    BanReload = "60", -- Time in seconds that that the Banlist would reload

    ----- AntiCheat Configuration -----

    AntiBlacklistEntities = true,

    AntiExplosions = true,

    AntiClearPedTasksImmediately = true,

    ----- Mass Spawn Configuration -----

    MaxPropSpawn = 10,

    MaxPedsSpawn = 5,

    MaxVehicleSpawn = 3,
}

D4rkAC = {
    Version = 1.0, -- Don't Touch
    License = "license:ADMINTESTING" -- License
}