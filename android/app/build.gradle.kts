plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // id("com.google.gms.google-services") // Retire si tu n'utilises pas Firebase
}

android {
    namespace = "com.example.gestion_ecole" // Change si tu as un autre ID
    compileSdk = flutter.compileSdkVersion
    ndkVersion = 21

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.gestion_ecole" // Change si besoin
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Si tu utilises Google Sign-In natif (rare avec Supabase), garde cette ligne :
    implementation("com.google.android.gms:play-services-auth:21.3.0")

    // Sinon, supprime toutes les dépendances Firebase/Google inutiles :
    // implementation(platform("com.google.firebase:firebase-bom:33.14.0"))
    // implementation("com.google.firebase:firebase-analytics")
    // implementation("com.google.firebase:firebase-auth")
}