package app.spring

import app.spring.fetcher.BookFetcher
import app.spring.graphql.client.SaveBookGraphQLQuery
import app.spring.graphql.client.SaveBookProjectionRoot
import app.spring.graphql.types.BookInput
import com.netflix.graphql.dgs.autoconfig.DgsAutoConfiguration
import com.netflix.graphql.dgs.client.codegen.GraphQLQueryRequest
import com.netflix.graphql.dgs.reactive.DgsReactiveQueryExecutor
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT
import org.springframework.context.annotation.ComponentScan
import org.testcontainers.containers.GenericContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.utility.DockerImageName
import reactor.test.StepVerifier

@EnableAutoConfiguration
@ComponentScan
@SpringBootTest(
    webEnvironment = RANDOM_PORT,
    classes = [
        DgsAutoConfiguration::class,
        BookFetcher::class,
    ]
)
class AppTests {

    @Autowired lateinit var queryExecutor: DgsReactiveQueryExecutor

    @Container
    var mongo: GenericContainer<*> = GenericContainer(
        DockerImageName.parse("mongo")
    ).withExposedPorts(27017).apply {
        addEnv("MONGODB_INITDB_ROOT_PASSWORD", "rootpass")
        addEnv("MONGODB_INITDB_ROOT_USERNAME", "rootuser")
    }

    @BeforeEach
    fun setUp() {
        mongo.start()
    }

    @AfterEach
    fun tearDown() {
        mongo.stop()
    }

    @Test
    fun save_book() {
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

        val response = queryExecutor.executeAndExtractJsonPath<String>(request.serialize(),
            "data.saveBook.title"
        )

        StepVerifier.create(response)
            .expectNext("Harry Potter and the Philosopher's Stone")
            .verifyComplete()
    }
}