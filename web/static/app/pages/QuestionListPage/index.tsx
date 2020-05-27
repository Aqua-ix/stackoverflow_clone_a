import React, { FC, useState, useEffect } from 'react'
import { Link, useHistory } from 'react-router-dom'
import { Header } from '@/app/components/Header'
import { Footer } from '@/app/components/Footer'
import { Question } from '@/app/models/Question'
import words from '@/assets/strings'
import style from '@/app/pages/QuestionListPage/style.scss'
import { QuestionItem } from '@/app/components/QuestionItem'
import { paths } from '@/app/common/paths'
import { QUESTION_LIMIT } from '@/app/common/constants'
import { retrieveQuestionsByUser, logout } from '@/app/common/api'
import { getCurrentUserId } from '@/app/common/utils'
import { SideBar } from '@/app/components/SideBar'

const QuestionListPage: FC = () => {
  const [questions, setQuestions] = useState<Question[]>([]) // このコンポーネントはstateとして質問一覧のデータを保持する。
  const history = useHistory()
  const currentUserId = getCurrentUserId()
  // useEffect()でページが表示される時に実行される処理を設定する。
  // https://reactjs.org/docs/hooks-reference.html#useeffect
  useEffect(() => {
    retrieveQuestionsByUser().then(items => {
      // よくわからない空白を追加する
      // GearのAPIから質問一覧を取得する。非同期で取得をするためにPromise()を利用する。
      setQuestions(items) // 取得した質問をこのコンポーネントのstateに保存する。stateを変更することで、コンポーネントの関数が再度実行される。
    })
  }, [])
  const handleLogin = () => {
    history.push(paths.login)
  }
  const sortedQuestions = questions.sort((a, b) => b.createdAt.localeCompare(a.createdAt))
  return (
    <>
      <Header userId={currentUserId} handleLogin={handleLogin} handleLogout={logout} />
      <div className={style.container}>
        <SideBar />
        <div className={style.main}>
          <div className={style.pageTitle}>{words.top.title}</div>
          <Link to={`${paths.questionCreate}`}>{words.top.question}</Link>
          <hr className={style.hr} />
          {/* 先頭からQUESTION_LIMITの件数だけ取り出して、それぞれQuestionItemに渡して表示をする */}
          {sortedQuestions.slice(0, QUESTION_LIMIT).map((question: Question) => (
            <QuestionItem key={`QuestionList_QuestionItem_${question.id}`} question={question} isUserIdShow />
          ))}
        </div>
      </div>
      <Footer />
    </>
  )
}
export default QuestionListPage
