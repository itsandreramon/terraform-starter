package app.spring.service

import app.spring.graphql.types.Book
import app.spring.graphql.types.BookInput
import app.spring.model.toDto
import app.spring.model.toEntity
import app.spring.repository.AuthorRepository
import app.spring.repository.BookRepository
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Component

interface BookService {
    fun getByUuid(uuid: String): Book?
    fun getAll(): List<Book>
    fun save(authorUuid: String, book: BookInput): Book?
}

@Component
class BookServiceImpl(
    private val bookRepository: BookRepository,
    private val authorRepository: AuthorRepository,
) : BookService {

    override fun getByUuid(uuid: String): Book? {
        return bookRepository.findById(uuid).orElse(null)?.toDto()
    }

    override fun getAll(): List<Book> {
        return bookRepository.findAll().map { it.toDto() }
    }

    override fun save(authorUuid: String, book: BookInput): Book? {
        val authorEntity = authorRepository.findByIdOrNull(authorUuid)

        return authorEntity?.let {
            val bookEntity = book.toEntity(authorEntity)
            bookRepository.save(bookEntity).toDto()
        }
    }
}
