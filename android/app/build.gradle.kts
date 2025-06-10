plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")

}

android {
    namespace = "com.example.gestion_ecole"
    compileSdk = 36 // Mise à jour vers la dernière version stable
    ndkVersion = 25 // Mise à jour pour une meilleure compatibilité

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_24
        targetCompatibility = JavaVersion.VERSION_24
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_24.toString()
    }

    defaultConfig {
        applicationId = "com.example.gestion_ecole"
        minSdk = 21 // Vérification de la compatibilité minimale
        targetSdk = 36
        versionCode = 2 // Mise à jour pour éviter les conflits
        versionName = "1.1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            minifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.gms:play-services-auth:21.3.0")

    // Ajout de dépendances essentielles pour la compatibilité et les performances
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.10.0")
}