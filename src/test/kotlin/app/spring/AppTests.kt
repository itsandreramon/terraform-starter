package app.spring

import app.spring.graphql.client.SaveAuthorGraphQLQuery
import app.spring.graphql.client.SaveAuthorProjectionRoot
import app.spring.graphql.client.SaveBookGraphQLQuery
import app.spring.graphql.client.SaveBookProjectionRoot
import app.spring.graphql.types.AuthorInput
import app.spring.graphql.types.BookInput
import com.netflix.graphql.dgs.DgsQueryExecutor
import com.netflix.graphql.dgs.client.codegen.GraphQLQueryRequest
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT
import org.springframework.test.context.DynamicPropertyRegistry
import org.springframework.test.context.DynamicPropertySource
import org.testcontainers.containers.MySQLContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.junit.jupiter.Testcontainers

@Testcontainers
@SpringBootTest(webEnvironment = RANDOM_PORT)
class AppTests {

    @Autowired lateinit var queryExecutor: DgsQueryExecutor

    @Test
    fun test_save_book() {
        val responseSaveAuthor = saveAuthor("J.K.", "Rowling")

        val inputBook = BookInput.newBuilder()
            .title("Harry Potter and the Philosopher's Stone")
            .build()

        val requestSaveBook = GraphQLQueryRequest(
            query = SaveBookGraphQLQuery.Builder()
                .authorUuid(responseSaveAuthor)
                .book(inputBook)
                .build(),
            projection = SaveBookProjectionRoot()
                .title()
        )

        val responseSaveBook = queryExecutor.executeAndExtractJsonPath<String>(
            requestSaveBook.serialize(),
            "data.saveBook.title"
        )

        assertEquals("Harry Potter and the Philosopher's Stone", responseSaveBook)
    }

    private fun saveAuthor(firstName: String, lastName: String): String {
        val inputAuthor = AuthorInput.newBuilder()
            .firstName(firstName)
            .lastName(lastName)
            .build()

        val requestSaveAuthor = GraphQLQueryRequest(
            query = SaveAuthorGraphQLQuery.Builder()
                .author(inputAuthor)
                .build(),
            projection = SaveAuthorProjectionRoot()
                .uuid()
        )

        return queryExecutor.executeAndExtractJsonPath(
            requestSaveAuthor.serialize(),
            "data.saveAuthor.uuid"
        )
    }

    companion object {

        @Container
        val mysql: MySQLContainer<*> = MySQLContainer("mysql")
            .withDatabaseName("test")
            .withUsername("root")
            .withPassword("password")

        @JvmStatic
        @DynamicPropertySource
        fun properties(registry: DynamicPropertyRegistry) {
            registry.add("spring.datasource.url", mysql::getJdbcUrl)
            registry.add("spring.datasource.password", mysql::getPassword)
            registry.add("spring.datasource.username", mysql::getUsername)
        }
    }
}
