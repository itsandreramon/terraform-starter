package app.spring.service

import app.spring.graphql.types.Book
import app.spring.graphql.types.BookInput
import app.spring.model.AuthorEntity
import app.spring.model.BookEntity
import app.spring.model.toDto
import app.spring.repository.AuthorRepository
import app.spring.repository.BookRepository
import io.mockk.every
import io.mockk.mockk
import java.util.Optional
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

class BookServiceTest {

    private val bookRepository = mockk<BookRepository>()
    private val authorRepository = mockk<AuthorRepository>()
    private var bookService: BookService? = null

    @BeforeEach
    fun setUp() {
        bookService = BookServiceImpl(bookRepository, authorRepository)
    }

    @AfterEach
    fun tearDown() {
        bookService = null
    }

    @Test
    fun test_entity_conversion() {
        val created = "2022-01-21T14:48:19.374212Z"
        val uuid = "eefc96ef-00b1-4a5a-9e7f-489691d04e09"

        val inputTitle = "Example Title"
        val inputAuthorUuid = "abc-123"

        val inputBook = BookInput.newBuilder()
            .title(inputTitle)
            .build()

        val author = AuthorEntity(
            uuid = inputAuthorUuid,
            firstName = "J.K.",
            lastName = "Rowling"
        )

        every {
            authorRepository.findById("abc-123")
        } returns Optional.of(author)

        every {
            bookRepository.save(any())
        } returns BookEntity(
            title = inputTitle,
            author = author,
            uuid = uuid,
            created = created,
        )

        val expected = Book.newBuilder()
            .author(author.toDto())
            .title(inputTitle)
            .uuid(uuid)
            .created(created)
            .build()

        val book = bookService!!.save(
            authorUuid = "abc-123",
            book = inputBook,
        )

        assertEquals(expected, book)
    }
}
