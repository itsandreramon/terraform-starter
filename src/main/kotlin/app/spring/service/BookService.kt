package app.spring.service

import app.spring.graphql.types.Book
import app.spring.graphql.types.BookInput
import app.spring.repository.BookRepository
import app.spring.util.toDto
import app.spring.util.toEntity
import org.springframework.stereotype.Component
import reactor.core.publisher.Mono

interface BookService {
	fun findById(id: Int): Mono<Book>
	fun findAll(): Mono<List<Book>>
	fun insert(book: BookInput): Mono<Book>
}

@Component
class BookServiceImpl(
	private val bookRepository: BookRepository,
) : BookService {

	override fun findById(id: Int): Mono<Book> {
		return bookRepository.findById(id)
			.map { it.toDto() }
	}

	override fun findAll(): Mono<List<Book>> {
		val booksFlux = bookRepository.findAll()
			.map { it.toDto() }

		return booksFlux.collectList()
	}

	override fun insert(book: BookInput): Mono<Book> {
		val bookEntity = book.toEntity()
		return bookRepository.save(bookEntity)
			.map { it.toDto() }
	}
}
