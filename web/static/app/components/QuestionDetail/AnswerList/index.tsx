import React, { FC, useCallback } from 'react'
import style from '@/app/components/QuestionDetail/AnswerList/style.scss'
import { Comment } from '@/app/models/Comment'
import words from '@/assets/strings'
import { CommentItem } from '@/app/components/CommentItem'
import { CommentPost } from '@/app/components/CommentPost'
import { Answer } from '@/app/models/Answer'
import { AnswerItem } from '@/app/components/AnswerItem'

interface Props {
  readonly userId: string
  readonly questionId: string
  readonly answers: Answer[]
  readonly createAnswerComment: (body: string, answerId: string, questionId: string) => void
  readonly updateAnswerComment: (body: string, answerId: string, id: string, questionId: string) => void
  readonly updateAnswer: (body: string, id: string, questionId: string) => void
}

export const AnswerList: FC<Props> = ({
  userId,
  questionId,
  answers,
  createAnswerComment,
  updateAnswerComment,
  updateAnswer,
}: Props) => {
  const updateAnswerBody = useCallback((body: string, id: string) => updateAnswer(body, id, questionId), [
    questionId,
    updateAnswer,
  ])

  const updateComment = (answerId: string, commentId: string) => (body: string) =>
    updateAnswerComment(body, answerId, commentId, questionId)

  const createComment = (answerId: string) => (body: string) => createAnswerComment(body, answerId, questionId)

  return (
    <div>
      <div className={style.answerListTitle}>{words.question.answerNumber(answers.length)}</div>
      <hr className={style.hr} />
      <div className={style.mainArea}>
        <div className={style.infoArea} />
        <span className={style.contentArea}>
          {answers.map((answer: Answer) => (
            <div key={answer.id}>
              <AnswerItem answer={answer} updateAnswer={updateAnswerBody} />
              {answer.comments.map((comment: Comment) => (
                <CommentItem
                  key={`${answer.id}_${comment.id}`}
                  comment={comment}
                  userId={userId}
                  updateComment={updateComment(answer.id, comment.id)}
                />
              ))}
              <CommentPost userId={userId} createComment={createComment(answer.id)} />
            </div>
          ))}
        </span>
      </div>
    </div>
  )
}
