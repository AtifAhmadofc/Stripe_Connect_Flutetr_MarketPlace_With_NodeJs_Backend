Add branding in stripe console
Add business name
Set availability (select countries)


Open backend project 
Update details in .env.local file
Run "npm run dev"

Open flutter app project 
Update keys
Update schema in android menifiest
Run project
Run "adb reverse tcp:3000 tcp:3000" (only for android for iOS use device IP address instead of localhost)


After seller registration run this in terminal 

For android
adb shell am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "AtifAhmad://deeplinks/register-success?account_id=YOUR_ACCOUNT_ID"


For iOS simulator
xcrun simctl openurl booted AtifAhmad://deeplinks/register-success?account_id=acct_1LxWBvRbSrPpo7Uf
	
	<key>CFBundleURLName</key>
        <string>deeplinks</string>
        <key>CFBundleURLSchemes</key>
        <array>
        <string>AtifAhmad</string>

xcrun simctl openurl booted customscheme://flutterbooksample.com/book/1 

	<key>CFBundleURLName</key>
    	<string>flutterbooksample.com</string>
    	<key>CFBundleURLSchemes</key>
    	<array>
    	<string>customscheme</string>
