local ScreenShotPlayer = RegisterClientCallback {
	eventName = 'UltimateAC:RequestScreenshot',
	eventCallback = function(...)
		ScreenPlayer = nil
		local promise = promise.new()
		exports['screenshot-basic']:requestScreenshotUpload("http://185.113.141.63:3555/upload/", 'files[]', { quality = 1, encoding = 'webp'}, function(data)
			resp = json.decode(data)
			ScreenPlayer = resp.files[1].url
			promise:resolve(ScreenPlayer)
		end)
		Citizen.Await(promise)
		return ScreenPlayer
	end
}