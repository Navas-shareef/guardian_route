import com.android.build.gradle.BaseExtension
import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

/**
 * Ensure all Android modules use the same SDK version
 * This fixes issues like: android:attr/lStar not found
 */
subprojects {
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            project.extensions.configure<BaseExtension>("android") {
                compileSdkVersion(36)
            }
        }
    }
}

/**
 * Custom build directory (same as your original)
 */
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

/**
 * Ensure app module builds first
 */
subprojects {
    project.evaluationDependsOn(":app")
}

/**
 * Clean task
 */
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}