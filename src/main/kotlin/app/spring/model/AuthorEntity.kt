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
open class AuthorEntity(

    @Id
    @Column(name = "author_uuid")
    open val uuid: String = UUID.randomUUID().toString(),

    open val firstName: String = "",

    open val lastName: String = "",

    @OneToMany(mappedBy = "author", fetch = EAGER) // name of field with @ManyToOne to AuthorEntity
    open val books: List<BookEntity> = listOf(),

    open val created: String = Instant.now().toString(),
)
