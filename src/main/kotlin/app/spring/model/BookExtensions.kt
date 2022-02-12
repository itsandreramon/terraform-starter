package app.spring.model

import app.spring.graphql.types.Book
import app.spring.graphql.types.BookInput

fun BookInput.toEntity(author: AuthorEntity): BookEntity {
    return BookEntity(
        title = this.title,
        author = author,
    )
}

fun BookEntity.toDto(): Book {
    val author = this.author?.toDto()

    return Book.newBuilder()
        .uuid(this.uuid)
        .title(this.title)
        .created(this.created)
        .author(author)
        .build()
}
