import React, { FC, useEffect, useState, useCallback } from 'react'
import { useHistory, useParams } from 'react-router-dom'
import { Header } from '@/app/components/Header'
import style from '@/app/pages/QuestionDetailPage/style.scss'
import { Question as QuestionModel } from '@/app/models/Question'
import { Answer } from '@/app/models/Answer'
import { VoteType } from '@/app/models/Vote'
import { AnswerPost } from '@/app/components/AnswerPost'
import { Question } from '@/app/components/QuestionDetail/Question'
import { paths } from '@/app/common/paths'
import { AnswerList } from '@/app/components/QuestionDetail/AnswerList'
import {
  retrieveQuestion,
  retrieveAnswers,
  createVote,
  logout,
  updateQuestion,
  createAnswer,
  updateAnswer,
  createQuestionComment,
  updateQuestionComment,
  createAnswerComment,
  updateAnswerComment,
} from '@/app/common/api'
import { getCurrentUserId } from '@/app/common/utils'

interface RouteParams {
  id: string
}

const QuestionDetailPage: FC = () => {
  const history = useHistory()
  const { id } = useParams<RouteParams>()

  const [question, setQuestion] = useState<QuestionModel | null>(null)
  const [answers, setAnswers] = useState<Answer[]>([])
  const currentUserId = getCurrentUserId()

  const retrieveUpdatedQuestion = useCallback(() => {
    retrieveQuestion(id).then(item => {
      setQuestion(item)
    })
  }, [id])

  const retrieveUpdatedAnswers = useCallback(() => {
    retrieveAnswers({ questionId: id }).then(items => {
      setAnswers(items)
    })
  }, [id])

  useEffect(() => {
    retrieveUpdatedQuestion()
    retrieveUpdatedAnswers()
  }, [retrieveUpdatedAnswers, retrieveUpdatedQuestion])

  const handleLogin = () => {
    history.push(paths.login)
  }
  const handleCreateVote = (questionId: string, voteType: VoteType) => {
    createVote(questionId, voteType).then(() => {
      return retrieveUpdatedQuestion()
    })
  }
  const handleUpdateQuestion = (title: string, body: string, id: string) => {
    updateQuestion(id, title, body).then(item => {
      setQuestion(item)
    })
  }
  const handlePostAnswer = (body: string) => {
    createAnswer(id, body).then(() => {
      return retrieveUpdatedAnswers()
    })
  }

  const handleUpdateAnswer = (body: string, id: string) => {
    updateAnswer(id, body).then(() => {
      return retrieveUpdatedAnswers()
    })
  }

  const handleCreateQuestionComment = (body: string, questionId: string) => {
    createQuestionComment(questionId, body).then(() => {
      return retrieveUpdatedQuestion()
    })
  }

  const handleUpdateQuestionComment = (body: string, questionId: string, id: string) => {
    updateQuestionComment(questionId, id, body).then(() => {
      return retrieveUpdatedQuestion()
    })
  }
  const handleCreateAnswerComment = (body: string, answerId: string) => {
    createAnswerComment(answerId, body).then(() => {
      return retrieveUpdatedAnswers()
    })
  }

  const handleUpdateAnswerComment = (body: string, answerId: string, id: string) => {
    updateAnswerComment(answerId, id, body).then(() => {
      return retrieveUpdatedAnswers()
    })
  }

  return (
    <>
      <Header userId={currentUserId} handleLogin={handleLogin} handleLogout={logout} />

      <div className={style.main}>
        {question && (
          <Question
            userId={currentUserId}
            questionId={id}
            question={question}
            updateQuestion={handleUpdateQuestion}
            createQuestionComment={handleCreateQuestionComment}
            updateQuestionComment={handleUpdateQuestionComment}
            createVote={handleCreateVote}
          />
        )}
        <AnswerList
          userId={currentUserId}
          questionId={id}
          answers={answers}
          createAnswerComment={handleCreateAnswerComment}
          updateAnswerComment={handleUpdateAnswerComment}
          updateAnswer={handleUpdateAnswer}
        />
        <AnswerPost userId={currentUserId} postAnswer={handlePostAnswer} />
      </div>
    </>
  )
}

export default QuestionDetailPage
