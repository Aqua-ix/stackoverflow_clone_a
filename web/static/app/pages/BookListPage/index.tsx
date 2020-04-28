import React, { FC, useState, useEffect } from 'react'
import { Link, useHistory } from 'react-router-dom'
import { Header } from '@/app/components/Header'
import { Footer } from '@/app/components/Footer'
import { Book } from '@/app/models/Book'
import words from '@/assets/strings'
import style from '@/app/pages/BookListPage/style.scss'
import { BookItem } from '@/app/components/BookItem'
import { paths } from '@/app/common/paths'
import { BOOK_LIMIT } from '@/app/common/constants'
import { retrieveBooks, logout } from '@/app/common/api'
import { getCurrentUserId } from '@/app/common/utils'

const BookListPage: FC = () => {
  const [books, setBooks] = useState<Book[]>([])
  const history = useHistory()
  const currentUserId = getCurrentUserId()

  useEffect(() => {
    retrieveBooks().then(items => {
      setBooks(items)
    })
  }, [])

  const handleLogin = () => {
    history.push(paths.login)
  }

  return (
    <>
      <Header userId={currentUserId} handleLogin={handleLogin} handleLogout={logout} />
      <div className={style.main}>
        <div className={style.pageTitle}>{words.bookList.title}</div>

        <Link to={`${paths.bookCreate}`}>{words.bookList.create}</Link>
        <hr className={style.hr} />

        {books.slice(0, BOOK_LIMIT).map((book: Book) => (
          <BookItem key={`BookList_BookItem_${book.id}`} book={book} />
        ))}
      </div>
      <Footer />
    </>
  )
}

export default BookListPage
