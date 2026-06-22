plugins {
    id("java")
    id("org.jetbrains.intellij.platform") version "2.5.0"
}

group = "com.narayann7"
// version comes from gradle.properties (single source of truth). Gradle sets
// project.version from the `version=` property automatically.

repositories {
    mavenCentral()
    intellijPlatform {
        defaultRepositories()
    }
}

dependencies {
    intellijPlatform {
        // Theme is platform-only, so the Community IDE is enough to build/run against.
        // The built plugin still installs into Android Studio (same platform).
        intellijIdeaCommunity("2024.2")
    }
}

intellijPlatform {
    pluginConfiguration {
        // Patches <version> in plugin.xml from the single source (project.version).
        version = project.version.toString()
        ideaVersion {
            sinceBuild = "233"
            // Open-ended: do not pin an upper bound, so it keeps loading in newer
            // Android Studio / IntelliJ builds.
            untilBuild = provider { null }
        }
    }

    // For publishing *updates* once the plugin already exists on the Marketplace:
    //   PUBLISH_TOKEN=<token> ./gradlew publishPlugin
    // The token is read from the environment only; never commit it.
    publishing {
        token = providers.environmentVariable("PUBLISH_TOKEN")
    }

    // Optional: sign the plugin before publishing (JetBrains recommends it).
    // Set CERTIFICATE_CHAIN, PRIVATE_KEY, PRIVATE_KEY_PASSWORD in the environment.
    // signing {
    //     certificateChain = providers.environmentVariable("CERTIFICATE_CHAIN")
    //     privateKey = providers.environmentVariable("PRIVATE_KEY")
    //     password = providers.environmentVariable("PRIVATE_KEY_PASSWORD")
    // }
}

tasks {
    wrapper {
        gradleVersion = "8.9"
    }
}
