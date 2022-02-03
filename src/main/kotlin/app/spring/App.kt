package app.spring

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.jdbc.datasource.DriverManagerDataSource
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import javax.sql.DataSource


@SpringBootApplication
@RestController
class App {

	@GetMapping
	fun hello(): String {
		return "Running..."
	}

	@Bean
	fun dataSource(): DataSource {
		val host: String = System.getenv("DB_HOST").takeUnless {
			it.isNullOrEmpty()
		} ?: "localhost"

		val port: String = System.getenv("DB_PORT").takeUnless {
			it.isNullOrEmpty()
		} ?: "3306"

		return DriverManagerDataSource().apply {
			username = "root"
			password = "password"
			url = "jdbc:mysql://$host:$port/db?createDatabaseIfNotExist=true"
		}
	}
}

fun main(args: Array<String>) {
	runApplication<App>(*args)
}
