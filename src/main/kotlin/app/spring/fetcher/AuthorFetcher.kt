package app.spring.fetcher

import app.spring.graphql.types.Author
import app.spring.graphql.types.AuthorInput
import app.spring.service.AuthorService
import com.netflix.graphql.dgs.DgsComponent
import com.netflix.graphql.dgs.DgsMutation
import com.netflix.graphql.dgs.DgsQuery
import com.netflix.graphql.dgs.InputArgument

@DgsComponent
class AuthorFetcher(private val authorService: AuthorService) {

    @DgsQuery
    fun getAllAuthors(): List<Author> {
        return authorService.getAll()
    }

    @DgsQuery
    fun getAuthorByUuid(
        @InputArgument uuid: String,
    ): Author? {
        return authorService.getByUuid(uuid)
    }

    @DgsMutation
    fun saveAuthor(
        @InputArgument author: AuthorInput,
    ): Author {
        return authorService.save(author)
    }
}
