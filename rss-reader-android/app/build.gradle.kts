plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    id("org.jetbrains.kotlin.plugin.serialization") version libs.versions.kotlin
}

android {
    namespace = "com.rowhomelabs.rssreader"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.rowhomelabs.rssreader"
        minSdk = 28
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildFeatures {
        buildConfig = true
    }

    buildTypes {
        debug {
            buildConfigField("String", "BASE_URL", "\"localhost:3000\"")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.constraintlayout)
    implementation("dev.hotwire:core:${libs.versions.hotwireNative}")
    implementation("dev.hotwire:navigation-fragments:${libs.versions.hotwireNative}")
    implementation("com.github.joemasilotti:bridge-components:0.12")
    implementation("androidx.browser:browser:1.8.0")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.7.3")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.8.7")
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}