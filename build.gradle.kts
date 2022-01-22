import com.netflix.graphql.dgs.codegen.gradle.GenerateJavaTask
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.springframework.boot.gradle.tasks.bundling.BootBuildImage

plugins {
    id("io.spring.dependency-management") version "1.0.11.RELEASE"
    id("org.springframework.boot") version "3.0.0-M1"
    id("com.netflix.dgs.codegen") version "5.1.16"
    kotlin("jvm") version "1.6.0"
    kotlin("plugin.spring") version "1.6.0"
    kotlin("plugin.serialization") version "1.6.0"
}

repositories {
    mavenCentral()
    maven { url = uri("https://repo.spring.io/milestone") }
}

apply(from = "ktlint.gradle.kts")

dependencies {
    implementation(platform(libs.netflix.dgs.bom))
    implementation(libs.netflix.dgs.starter)

    implementation(libs.spring.mongo)
    implementation(libs.spring.webflux)

    implementation(libs.reactor.kotlin)
    implementation(libs.kotlin.stdlib)

    testImplementation(platform(libs.testcontainers.bom))
    testImplementation(libs.testcontainers.junit)
    testImplementation(libs.testcontainers.mongo)

    testImplementation(libs.mockk)
    testImplementation(libs.kotest.assertions)
    testImplementation(libs.reactor.test)
    testImplementation(libs.spring.test)
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
    generateClient = true
}

group = "app"
java.sourceCompatibility = JavaVersion.VERSION_17