## Steps to build apk for new instance

cd android
.\gradlew.bat clean

C:\Program Files\Java\jre1.8.0_261\bin (admin rights) keytool -genkey -v -keystore
keytool -genkey -v -keystore nithinorganics.keystore -alias simpfonithinorganicskeystore -keyalg RSA -keysize 2048 -validity 10000
S!mpf0@2019

$cd android; ./gradlew signingReport


    1. Change the base api url in main.dart, Change the app icon title in "android/app/src/main/AndroidManifest.xml"
    2. Change the applicationId in android/app/build.gradle, replace "com.simpfo.halliangadi" with the corresponding new name in all the files where it is used
    3. Generate .keystore file, copy the file in android/app folder, update the keystore file name and alias in signingConfigs section of android/app/build.gradle file
    4. Generate the SHA Key and add the same to firebase android app settings ($cd android; ./gradlew signingReport)
    5. Update the android/app/google-services.json file with corresponding firebase settings


====================SHA Keys====================
nithinorganics:

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
==================================

halliangadi

Variant: debug
Config: debug
Store: D:\b2bAdminApp\b2bAdminApp\android\app\halliangadi.keystore
Alias: simpfohalliangadikeystore
MD5: 74:61:76:98:2C:96:30:46:86:6F:06:FB:76:40:F8:7C
SHA1: 58:99:0E:75:6E:D3:F0:40:CE:E0:41:55:86:D0:05:AD:27:27:C7:0F
SHA-256: 6E:D1:B5:EB:77:71:B5:18:49:D0:BF:BD:DB:36:60:85:A1:16:81:72:BD:02:E6:7B:B2:10:10:C5:31:54:DC:F6
Valid until: Friday, 5 March, 2049
----------
Variant: release
Config: release
Store: D:\b2bAdminApp\b2bAdminApp\android\app\halliangadi.keystore
Alias: simpfohalliangadikeystore
MD5: 74:61:76:98:2C:96:30:46:86:6F:06:FB:76:40:F8:7C
SHA1: 58:99:0E:75:6E:D3:F0:40:CE:E0:41:55:86:D0:05:AD:27:27:C7:0F
SHA-256: 6E:D1:B5:EB:77:71:B5:18:49:D0:BF:BD:DB:36:60:85:A1:16:81:72:BD:02:E6:7B:B2:10:10:C5:31:54:DC:F6
Valid until: Friday, 5 March, 2049
================================================
fleshandfresh

keytool -genkey -v -keystore fleshandfresh.keystore -alias simpfofleshandfreshkeystore -keyalg RSA -keysize 2048 -validity 10000
Variant: debug 
Config: debug 
Store: D:\Simpfo\Src\ecommerce_b2b\b2c_nihin\b2b_admin_flutter\android\app\fleshandfresh.keystore 
Alias: simpfofleshandfreshkeystore MD5: EF:3F:F9:A3:7A:B4:51:B0:1B:C6:23:DC:37:70:D5:73 
SHA1: 04:45:27:84:A0:75:08:46:78:A0:62:DA:63:F8:4A:D2:85:2D:9E:16 
SHA-256: 92:F9:3E:3B:62:D7:D0:AB:92:8F:1E:4D:36:99:2B:72:93:CB:A5:A3:08:50:31:38:01:8C:92:C4:35:95:A8:37 
Valid until: Friday, 23 April, 2049

Variant: release 
Config: release 
Store: D:\Simpfo\Src\ecommerce_b2b\b2c_nihin\b2b_admin_flutter\android\app\fleshandfresh.keystore 
Alias: simpfofleshandfreshkeystore MD5: EF:3F:F9:A3:7A:B4:51:B0:1B:C6:23:DC:37:70:D5:73 
SHA1: 04:45:27:84:A0:75:08:46:78:A0:62:DA:63:F8:4A:D2:85:2D:9E:16 
SHA-256: 92:F9:3E:3B:62:D7:D0:AB:92:8F:1E:4D:36:99:2B:72:93:CB:A5:A3:08:50:31:38:01:8C:92:C4:35:95:A8:37 
Valid until: Friday, 23 April, 2049
=======================================================
halliorganics
keytool -genkey -v -keystore halliorganics.keystore -alias simpfohalliorganicskeystore -keyalg RSA -keysize 2048 -validity 10000
S!mpf0@2019

Variant: debug
Config: debug
Store: D:\Simpfo\Src\ecommerce_b2b\b2c_nihin\b2b_admin_flutter\android\app\halliorganics.keystore
Alias: simpfohalliorganicskeystore
MD5: 9E:B3:77:61:B6:47:E5:D3:DC:78:68:DE:95:70:16:4D
SHA1: 6E:66:FF:09:EA:1B:2A:6B:22:D4:41:D1:05:BB:EE:DC:4D:80:59:AD
SHA-256: 7F:E7:5A:30:B7:E4:38:6E:33:7A:6D:C3:BF:40:FF:03:44:E6:F7:DD:BB:CE:BB:73:EB:34:0B:8C:7C:9F:6C:B3
Valid until: Tuesday, 27 April, 2049
----------
Variant: release
Config: release
Store: D:\Simpfo\Src\ecommerce_b2b\b2c_nihin\b2b_admin_flutter\android\app\halliorganics.keystore
Alias: simpfohalliorganicskeystore
MD5: 9E:B3:77:61:B6:47:E5:D3:DC:78:68:DE:95:70:16:4D
SHA1: 6E:66:FF:09:EA:1B:2A:6B:22:D4:41:D1:05:BB:EE:DC:4D:80:59:AD
SHA-256: 7F:E7:5A:30:B7:E4:38:6E:33:7A:6D:C3:BF:40:FF:03:44:E6:F7:DD:BB:CE:BB:73:EB:34:0B:8C:7C:9F:6C:B3
Valid until: Tuesday, 27 April, 2049
----------
