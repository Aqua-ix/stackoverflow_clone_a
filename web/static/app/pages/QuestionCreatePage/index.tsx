import React, { FC } from 'react'
import { useHistory } from 'react-router-dom'
import { Header } from '@/app/components/Header'
import { Footer } from '@/app/components/Footer'
import { paths } from '@/app/common/paths'
import { QuestionPost } from '@/app/components/QuestionPost'
import { createQuestion, logout } from '@/app/common/api'
import { Question } from '@/app/models/Question'
import { getCurrentUserId } from '@/app/common/utils'

const QuestionCreatePage: FC = () => {
  const history = useHistory()
  const currentUserId = getCurrentUserId()

  const handleLogin = () => {
    history.push(paths.login)
  }
  const handleSubmit = (title: string, body: string) => {
    createQuestion(title, body).then((item: Question) => {
      history.push(paths.question(item.id))
    })
  }

  return (
    <>
      <Header userId={currentUserId} handleLogin={handleLogin} handleLogout={logout} />
      <QuestionPost handleSubmit={handleSubmit} />
      <Footer />
    </>
  )
}

export default QuestionCreatePage
