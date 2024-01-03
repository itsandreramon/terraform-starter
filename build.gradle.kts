import com.netflix.graphql.dgs.codegen.gradle.GenerateJavaTask
import kotlinx.kover.api.KoverTaskExtension
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.springframework.boot.gradle.tasks.bundling.BootBuildImage

plugins {
    id("io.spring.dependency-management") version "1.0.11.RELEASE"
    id("org.springframework.boot") version "2.6.3"
    id("org.jetbrains.kotlinx.kover") version "0.5.0-RC2"
    id("com.netflix.dgs.codegen") version "5.12.4"
    kotlin("jvm") version "1.6.0"
    kotlin("plugin.jpa") version "1.6.0"
    kotlin("plugin.allopen") version "1.6.0"
    kotlin("plugin.spring") version "1.6.0"
    kotlin("plugin.serialization") version "1.6.0"
}

allOpen {
    annotation("javax.persistence.Entity")
    annotation("javax.persistence.Embeddable")
    annotation("javax.persistence.MappedSuperclass")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(platform(libs.netflix.dgs.bom))
    implementation(libs.netflix.dgs.starter)

    implementation(libs.spring.jpa)
    implementation(libs.spring.web)

    implementation(libs.kotlin.stdlib)

    runtimeOnly(libs.mysql)

    testImplementation(platform(libs.testcontainers.bom))
    testImplementation(libs.testcontainers.junit)
    testImplementation(libs.testcontainers.mysql)

    testImplementation(libs.mockk)
    testImplementation(libs.kotest.assertions)
    testImplementation(libs.spring.test)
}

apply(from = "ktlint.gradle.kts")

tasks.test {
    extensions.configure(KoverTaskExtension::class) {
        includes = listOf("app.spring.*")
        excludes = listOf("app.spring.graphql.*")
    }
}

tasks.withType<KotlinCompile> {
    dependsOn("generateJava")

    kotlinOptions {
        freeCompilerArgs = listOf("-Xjsr305=strict")
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}

tasks.withType<BootBuildImage> {
    imageName = "spring:latest"
}

tasks.withType<GenerateJavaTask> {
    schemaPaths = mutableListOf("${projectDir}/src/main/resources/schema")
    packageName = "app.spring.graphql"
    language = "kotlin"
    generateClient = true
}

group = "app"
java.sourceCompatibility = JavaVersion.VERSION_17
