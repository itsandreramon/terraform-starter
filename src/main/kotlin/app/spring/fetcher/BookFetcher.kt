package app.spring.fetcher

import app.spring.graphql.types.Book
import app.spring.graphql.types.BookInput
import app.spring.service.BookService
import com.netflix.graphql.dgs.DgsComponent
import com.netflix.graphql.dgs.DgsMutation
import com.netflix.graphql.dgs.DgsQuery
import com.netflix.graphql.dgs.InputArgument

@DgsComponent
class BookFetcher(private val bookService: BookService) {

    @DgsQuery
    fun getAllBooks(): List<Book> {
        return bookService.getAll()
    }

    @DgsQuery
    fun getBookByUuid(
        @InputArgument uuid: String,
    ): Book? {
        return bookService.getByUuid(uuid)
    }

    @DgsMutation
    fun saveBook(
        authorUuid: String,
        @InputArgument book: BookInput,
    ): Book? {
        return bookService.save(authorUuid, book)
    }
}
