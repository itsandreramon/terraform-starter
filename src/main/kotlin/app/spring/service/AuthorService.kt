package app.spring.service

import app.spring.graphql.types.Author
import app.spring.graphql.types.AuthorInput
import app.spring.model.toDto
import app.spring.model.toEntity
import app.spring.repository.AuthorRepository
import org.springframework.stereotype.Component

interface AuthorService {
    fun getByUuid(uuid: String): Author?
    fun getAll(): List<Author>
    fun save(author: AuthorInput): Author
}

@Component
class AuthorServiceImpl(
    private val authorRepository: AuthorRepository,
) : AuthorService {

    override fun getByUuid(uuid: String): Author? {
        return authorRepository.findById(uuid).orElse(null)?.toDto()
    }

    override fun getAll(): List<Author> {
        return authorRepository.findAll().map { it.toDto() }
    }

    override fun save(author: AuthorInput): Author {
        val authorEntity = author.toEntity()
        return authorRepository.save(authorEntity).toDto()
    }
}
