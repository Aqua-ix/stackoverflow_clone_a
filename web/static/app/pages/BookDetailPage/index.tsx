import React, { FC, useEffect, useState, useCallback } from 'react'
import { useHistory, useParams } from 'react-router-dom'
import { Header } from '@/app/components/Header'
import style from '@/app/pages/BookDetailPage/style.scss'
import { Book as BookModel } from '@/app/models/Book'
import { Book } from '@/app/components/BookDetail/Book'
import { paths } from '@/app/common/paths'
import { retrieveBook, logout, updateBook } from '@/app/common/api'
import { getCurrentUserId } from '@/app/common/utils'

interface RouteParams {
  id: string
}

const BookDetailPage: FC = () => {
  const history = useHistory()
  const { id } = useParams<RouteParams>()

  const [book, setBook] = useState<BookModel | null>(null)
  const currentUserId = getCurrentUserId()

  const retrieveUpdatedBook = useCallback(() => {
    retrieveBook(id).then(item => {
      setBook(item)
    })
  }, [id])

  useEffect(() => {
    retrieveUpdatedBook()
  }, [retrieveUpdatedBook])

  const handleLogin = () => {
    history.push(paths.login)
  }
  const handleUpdateBook = (title: string, body: string, id: string) => {
    updateBook(id, title, body).then(item => {
      setBook(item)
    })
  }

  return (
    <>
      <Header userId={currentUserId} handleLogin={handleLogin} handleLogout={logout} />

      <div className={style.main}>{book && <Book bookId={id} book={book} updateBook={handleUpdateBook} />}</div>
    </>
  )
}

export default BookDetailPage
