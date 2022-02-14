package app.spring.model

import java.time.Instant
import java.util.UUID
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType.EAGER
import javax.persistence.Id
import javax.persistence.OneToMany
import javax.persistence.Table

@Entity
@Table(name = "authors")
class AuthorEntity(

    @Id
    @Column(name = "author_uuid")
    val uuid: String = UUID.randomUUID().toString(),

    val firstName: String = "",

    val lastName: String = "",

    @OneToMany(mappedBy = "author", fetch = EAGER)
    val books: List<BookEntity> = listOf(),

    val created: String = Instant.now().toString(),
)
