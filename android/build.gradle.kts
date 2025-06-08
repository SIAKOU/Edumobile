plugins {
    // Aucun plugin Google/Firebase requis pour Supabase
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Définir le dossier de build global pour tous les sous-projets
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Tâche clean personnalisée
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}