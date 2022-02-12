package app.spring.model

import app.spring.graphql.types.Author
import app.spring.graphql.types.AuthorInput

fun AuthorInput.toEntity(): AuthorEntity {
    return AuthorEntity(
        firstName = this.firstName,
        lastName = this.lastName,
    )
}

fun AuthorEntity.toDto(): Author {
    val books = this.books.map { it.toDto() }

    return Author.newBuilder()
        .uuid(this.uuid)
        .firstName(this.firstName)
        .lastName(this.lastName)
        .created(this.created)
        .books(books)
        .build()
}
