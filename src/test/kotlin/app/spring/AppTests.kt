package app.spring

import app.spring.fetcher.BookFetcher
import app.spring.graphql.client.SaveBookGraphQLQuery
import app.spring.graphql.client.SaveBookProjectionRoot
import app.spring.graphql.types.BookInput
import com.netflix.graphql.dgs.DgsQueryExecutor
import com.netflix.graphql.dgs.autoconfig.DgsAutoConfiguration
import com.netflix.graphql.dgs.client.codegen.GraphQLQueryRequest
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT
import org.springframework.context.annotation.ComponentScan
import org.springframework.test.context.DynamicPropertyRegistry
import org.springframework.test.context.DynamicPropertySource
import org.testcontainers.containers.MySQLContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.junit.jupiter.Testcontainers

@ComponentScan
@EnableAutoConfiguration
@SpringBootTest(
	webEnvironment = RANDOM_PORT,
	classes = [
		DgsAutoConfiguration::class,
		BookFetcher::class,
	]
)
@Testcontainers
class AppTests {

	@Autowired lateinit var queryExecutor: DgsQueryExecutor

	@Test
	fun test_save_book() {
		val input = BookInput.newBuilder()
			.title("Harry Potter and the Philosopher's Stone")
			.author("J. K. Rowling")
			.build()

		val request = GraphQLQueryRequest(
			query = SaveBookGraphQLQuery.Builder()
				.book(input)
				.build(),
			projection = SaveBookProjectionRoot()
				.title()
		)

		val response = queryExecutor.executeAndExtractJsonPath<String>(
			request.serialize(),
			"data.saveBook.title"
		)

		assertEquals("Harry Potter and the Philosopher's Stone", response)
	}

	companion object {

		@Container
		val mysql: MySQLContainer<*> = MySQLContainer("mysql")

		@JvmStatic
		@DynamicPropertySource
		fun properties(registry: DynamicPropertyRegistry) {
			registry.add("spring.datasource.url", mysql::getJdbcUrl)
		}
	}
}
