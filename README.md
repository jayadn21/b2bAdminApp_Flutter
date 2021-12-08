cd android
.\gradlew.bat clean
===========
nithinorganics:
C:\Program Files\Java\jre1.8.0_261\bin (admin rights)
keytool -genkey -v -keystore nithinorganics.keystore -alias simpfonithinorganicskeystore -keyalg RSA -keysize 2048 -validity 10000
S!mpf0@2019

$cd android; ./gradlew signingReport
SHA Key:
Variant: debug
Config: debug
Store: D:\src\ecommerce\android\app\nithinorganics.keystore
Alias: simpfonithinorganicskeystore
MD5: 67:A6:9D:33:E2:D0:0C:28:FC:1C:C0:9F:26:5C:7B:1A
SHA1: B8:77:1B:93:64:65:A7:66:7E:E7:13:45:1E:78:97:78:48:86:9E:72
SHA-256: 78:A1:D6:C0:59:57:08:54:8A:FC:77:74:2C:DE:89:E6:D0:82:5D:DB:62:E7:28:DA:A4:7D:8D:4F:DF:3A:4E:59
Valid until: Friday, February 26, 2049
----------
Variant: release
Config: release
Store: D:\src\ecommerce\android\app\nithinorganics.keystore
Alias: simpfonithinorganicskeystore
MD5: 67:A6:9D:33:E2:D0:0C:28:FC:1C:C0:9F:26:5C:7B:1A
SHA1: B8:77:1B:93:64:65:A7:66:7E:E7:13:45:1E:78:97:78:48:86:9E:72
SHA-256: 78:A1:D6:C0:59:57:08:54:8A:FC:77:74:2C:DE:89:E6:D0:82:5D:DB:62:E7:28:DA:A4:7D:8D:4F:DF:3A:4E:59
Valid until: Friday, February 26, 2049

## Steps to deploy to new Customer:
1. Change the base api url in main.dart
2. Change the applicationId in android/app/build.gradle, replace "com.simpfo.halliangadi" with the corresponding new name in all the files where it is used.
3. Generate <customerStore>.keystore file, copy the file in android/app folder, update the keystore file name and alias in signingConfigs section of android/app/build.gradle file 
4. Generate the SHA Key and add the same to firebase android app settings ($cd android; ./gradlew signingReport)
5. Update the android/app/google-services.json file with corresponding firebase settings


## fleshandfresh
keytool -genkey -v -keystore fleshandfresh.keystore -alias simpfofleshandfreshkeystore -keyalg RSA -keysize 2048 -validity 10000

Variant: debug
Config: debug
Store: D:\Simpfo\Src\ecommerce_b2b\b2c_nihin\b2b_admin_flutter\android\app\fleshandfresh.keystore
Alias: simpfofleshandfreshkeystore
MD5: EF:3F:F9:A3:7A:B4:51:B0:1B:C6:23:DC:37:70:D5:73
SHA1: 04:45:27:84:A0:75:08:46:78:A0:62:DA:63:F8:4A:D2:85:2D:9E:16
SHA-256: 92:F9:3E:3B:62:D7:D0:AB:92:8F:1E:4D:36:99:2B:72:93:CB:A5:A3:08:50:31:38:01:8C:92:C4:35:95:A8:37
Valid until: Friday, 23 April, 2049
----------
Variant: release
Config: release
Store: D:\Simpfo\Src\ecommerce_b2b\b2c_nihin\b2b_admin_flutter\android\app\fleshandfresh.keystore
Alias: simpfofleshandfreshkeystore
MD5: EF:3F:F9:A3:7A:B4:51:B0:1B:C6:23:DC:37:70:D5:73
SHA1: 04:45:27:84:A0:75:08:46:78:A0:62:DA:63:F8:4A:D2:85:2D:9E:16
SHA-256: 92:F9:3E:3B:62:D7:D0:AB:92:8F:1E:4D:36:99:2B:72:93:CB:A5:A3:08:50:31:38:01:8C:92:C4:35:95:A8:37
Valid until: Friday, 23 April, 2049
