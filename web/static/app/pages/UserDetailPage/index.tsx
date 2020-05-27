import React, { FC, useEffect, useState } from 'react'
import { useHistory, useParams } from 'react-router-dom'

import { Header } from '@/app/components/Header'
import { Footer } from '@/app/components/Footer'

import { Question } from '@/app/models/Question'
import { Answer } from '@/app/models/Answer'

import words from '@/assets/strings'
import style from '@/app/pages/UserDetailPage/style.scss'
import { QuestionItem } from '@/app/components/QuestionItem'
import { AnswerOverview } from '@/app/components/AnswerOverview'
import { paths } from '@/app/common/paths'
import { QUESTION_LIMIT } from '@/app/common/constants'
import { retrieveQuestionsByUser, retrieveAnswers, logout } from '@/app/common/api'
import { getCurrentUserId, } from '@/app/common/utils'
import { SideBar } from '@/app/components/SideBar'


interface RouteParams {
  userId: string
}

const UserDetailPage: FC = () => {
  const history = useHistory()
  const { userId } = useParams<RouteParams>()
  
  const [questions, setQuestion] = useState<Question[]>([])
  const [answers, setAnswers] = useState<Answer[]>([])
  const currentUserId = getCurrentUserId()

  const handleLogin = () => {
    history.push(paths.login)
  }

  useEffect(() => {
    retrieveQuestionsByUser(userId).then(items =>{
      setQuestion(items)
    })
    retrieveAnswers({ userId: userId }).then(items => {
      setAnswers(items)
    })
  }, [userId])

  return (
    <>
      <Header userId={currentUserId} handleLogin={handleLogin} handleLogout={logout} />
      <div className={style.container}>
      <SideBar/>
        <div className={style.main}>
          <div className={style.pageTitle}>{words.user.title}</div>
          <hr className={style.hr} />
          <div className={style.listTitle}>{words.user.questionList}</div>
          {questions.slice(0,QUESTION_LIMIT).map((question: Question) => (
            <QuestionItem key={`QuestionList_QuestionItem_${question.id}`} question={question}/>
          ))}
          <div className={style.listTitle}>{words.user.answerList}</div>
          {answers.slice(0,QUESTION_LIMIT).map((answer: Answer) => (
            <AnswerOverview key={`AnswerOverview_${answer.id}`} answer={answer}/>
          ))}
        </div>
      </div>

      <Footer />
    </>
  )
}

export default UserDetailPage
