package app.spring

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.web.bind.annotation.RestController


@SpringBootApplication
@RestController
class App

fun main(args: Array<String>) {
	runApplication<App>(*args)
}
