package app.spring.model

import java.time.Instant
import java.util.UUID
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table

@Entity
@Table(name = "books")
class BookEntity(

    @Id
    @Column(name = "book_uuid")
    val uuid: String = UUID.randomUUID().toString(),

    val title: String = "",

    @ManyToOne
    @JoinColumn(name = "author_uuid", nullable = false)
    val author: AuthorEntity,

    val created: String = Instant.now().toString(),
)
