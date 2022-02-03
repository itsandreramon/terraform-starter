package app.spring.model

import java.time.Instant
import java.util.UUID
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "books")
open class BookEntity(

	@Id
	open val uuid: String = UUID.randomUUID().toString(),

	open val title: String = "",

	open val author: String = "",

	open val created: String = Instant.now().toString(),
)
