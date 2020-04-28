import React, { FC } from 'react'
import { useHistory } from 'react-router-dom'
import { Header } from '@/app/components/Header'
import { Footer } from '@/app/components/Footer'
import { paths } from '@/app/common/paths'
import { BookPost } from '@/app/components/BookPost'
import { createBook, logout } from '@/app/common/api'
import { Book } from '@/app/models/Book'
import { getCurrentUserId } from '@/app/common/utils'

const BookCreatePage: FC = () => {
  const history = useHistory()
  const currentUserId = getCurrentUserId()

  const handleLogin = () => {
    history.push(paths.login)
  }
  const handleSubmit = (title: string, body: string) => {
    createBook(title, body).then((item: Book) => {
      history.push(paths.book(item.id))
    })
  }

  return (
    <>
      <Header userId={currentUserId} handleLogin={handleLogin} handleLogout={logout} />
      <BookPost handleSubmit={handleSubmit} />
      <Footer />
    </>
  )
}

export default BookCreatePage
