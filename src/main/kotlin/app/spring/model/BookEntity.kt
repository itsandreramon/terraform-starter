package app.spring.model

import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.time.Instant
import java.util.UUID

@Entity
@Table(name = "books")
open class BookEntity(

	@Id
	val uuid: String = UUID.randomUUID().toString(),

	val title: String = "",

	val author: String = "",

	val created: String = Instant.now().toString(),
)
