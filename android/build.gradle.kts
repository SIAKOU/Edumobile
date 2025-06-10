plugins {
    // Aucun plugin Google/Firebase requis pour Supabase
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Définition du dossier de build global pour tous les sous-projets
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Tâche clean améliorée avec une vérification de l'existence du dossier avant suppression
tasks.register<Delete>("clean") {
    doFirst {
        val buildDir = rootProject.layout.buildDirectory.get().asFile
        if (buildDir.exists()) {
            println("Suppression du dossier de build...")
        } else {
            println("Aucun dossier de build à supprimer.")
        }
    }
    delete(rootProject.layout.buildDirectory)
}