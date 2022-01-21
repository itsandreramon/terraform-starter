package app.spring.util

import app.spring.graphql.types.Book
import app.spring.graphql.types.BookInput
import app.spring.model.BookEntity

fun BookInput.toEntity(): BookEntity {
    return BookEntity(
        title = this.title,
        author = this.author,
    )
}

fun BookEntity.toDto(): Book {
    return Book.newBuilder()
        .id(this.id)
        .author(this.author)
        .title(this.title)
        .created(this.created)
        .build()
}