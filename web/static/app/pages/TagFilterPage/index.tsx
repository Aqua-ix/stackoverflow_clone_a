import React, { FC, useEffect, useState } from 'react'
import { useHistory, useParams } from 'react-router-dom'

import { Header } from '@/app/components/Header'
import { Footer } from '@/app/components/Footer'

import { Question } from '@/app/models/Question'

import words from '@/assets/strings'
import style from '@/app/pages/UserDetailPage/style.scss'
import { QuestionItem } from '@/app/components/QuestionItem'
import { paths } from '@/app/common/paths'
import { QUESTION_LIMIT } from '@/app/common/constants'
import { retrieveQuestionsByTag, logout } from '@/app/common/api'
import { getCurrentUserId } from '@/app/common/utils'

interface RouteParams {
  tag: string
}

const TagFilterPage: FC = () => {
  const history = useHistory()
  const { tag } = useParams<RouteParams>()

  const [questions, setQuestion] = useState<Question[]>([])
  const CurrentUserId = getCurrentUserId()

  const handleLogin = () => {
    history.push(paths.login)
  }

  useEffect(() => {
    retrieveQuestionsByTag(tag).then(items => {
      setQuestion(items)
    })
  }, [tag])

  return (
    <>
      <Header userId={CurrentUserId} handleLogin={handleLogin} handleLogout={logout} />

      <div className={style.main}>
        <div className={style.pageTitle}>{words.tag.description(tag)}</div>
        <hr className={style.hr} />
        {questions.slice(0, QUESTION_LIMIT).map((question: Question) => (
          <QuestionItem key={`QuestionList_QuestionItem_${question.id}`} question={question} isUserIdShow />
        ))}
      </div>

      <Footer />
    </>
  )
}

export default TagFilterPage
