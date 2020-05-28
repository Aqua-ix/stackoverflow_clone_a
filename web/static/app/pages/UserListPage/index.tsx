import React, { FC, useEffect, useState } from 'react'
import { useHistory, useParams } from 'react-router-dom'
import { Header } from '@/app/components/Header'
import { Footer } from '@/app/components/Footer'
import { paths } from '@/app/common/paths'
import { SideBar } from '@/app/components/SideBar'
import { Question } from '@/app/models/Question'
import words from '@/assets/strings'
import style from '@/app/pages/QuestionListPage/style.scss'
import { retrieveQuestionsByUser, logout } from '@/app/common/api'
import { getCurrentUserId } from '@/app/common/utils'

interface RouteParams {
  userId: string
}

const UserListPage: FC = () => {
  const history = useHistory()
  const { userId } = useParams<RouteParams>()

  const [questions, setQuestion] = useState<Question[]>([])
  const CurrentUserId = getCurrentUserId()
  console.log(questions)
  console.log(userId)
  
  useEffect(() => {
    retrieveQuestionsByUser().then(items => {
      setQuestion(items)
    })
  }, [])

  const handleLogin = () => {
    history.push(paths.login)
  }
  
  return(
    <>
      <Header userId={CurrentUserId} handleLogin={handleLogin} handleLogout={logout}/>
      <div className={style.container}>
          <SideBar />
          <div className={style.main}>
            <div className={style.pageTitle}>{words.top.users}</div>
            <hr className={style.hr} />
          </div>
        </div>
      <Footer />
    </>
  )
}

export default UserListPage
