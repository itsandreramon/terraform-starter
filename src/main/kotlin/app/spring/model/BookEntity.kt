package app.spring.model

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.index.Indexed
import org.springframework.data.mongodb.core.mapping.Document
import java.time.Instant

@Document
data class BookEntity(
    @Id val id: Int = 0,
    @Indexed val title: String,
    val author: String,
    val created: String = Instant.now().toString(),
)