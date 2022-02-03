package app.spring.repository

import app.spring.model.BookEntity
import org.springframework.data.jpa.repository.JpaRepository

interface BookRepository : JpaRepository<BookEntity, String>
