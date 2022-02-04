package app.spring.service

import app.spring.graphql.types.Book
import app.spring.graphql.types.BookInput
import app.spring.model.toDto
import app.spring.model.toEntity
import app.spring.repository.BookRepository
import org.springframework.stereotype.Component

interface BookService {
    fun getByUuid(uuid: String): Book?
    fun getAll(): List<Book>
    fun save(book: BookInput): Book
}

@Component
class BookServiceImpl(
    private val bookRepository: BookRepository,
) : BookService {

    override fun getByUuid(uuid: String): Book? {
        return bookRepository.findById(uuid).orElse(null)?.toDto()
    }

    override fun getAll(): List<Book> {
        return bookRepository.findAll().map { it.toDto() }
    }

    override fun save(book: BookInput): Book {
        val bookEntity = book.toEntity()
        return bookRepository.save(bookEntity).toDto()
    }
}
