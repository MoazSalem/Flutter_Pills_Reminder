import java.io.File
import java.io.FileInputStream
import java.util.*

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Define the helper extension function
fun Properties.getRequiredProperty(key: String): String {
    return getProperty(key) ?: throw IllegalArgumentException("'$key' not found in keystore.properties file.")
}

// Create an empty Properties object
val keyProperties = Properties()
val propertiesFile = File("keystore.properties")

var detStoreFile: String? = null
var detStorePassword: String? = null
var detKeyAlias: String? = null
var detKeyPassword: String? = null

// Check if the properties file exists before doing anything else
if (propertiesFile.exists()) {
    println("Info: keystore.properties found. Loading signing information.")

    // Load the file's contents into the properties object
    keyProperties.load(FileInputStream(propertiesFile))

    // get the required properties. This code only runs if the file exists.
    detKeyAlias = keyProperties.getRequiredProperty("keyAlias")
    detKeyPassword = keyProperties.getRequiredProperty("keyPassword")
    detStoreFile = keyProperties.getRequiredProperty("storeFile")
    detStorePassword = keyProperties.getRequiredProperty("storePassword")

} else {
    // This message will now appear when building without the file
    println("Warning: keystore.properties not found. Skipping release signing configuration.")
}

android {
    namespace = "com.moazsalem.pills_reminder"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.moazsalem.pills_reminder"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            if (detStoreFile != null) {
                storeFile = file(detStoreFile!!)
                storePassword = detStorePassword
                keyAlias = detKeyAlias
                keyPassword = detKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}