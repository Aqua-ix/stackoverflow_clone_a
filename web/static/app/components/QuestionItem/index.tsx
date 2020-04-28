import React, { FC } from 'react'
import { Link } from 'react-router-dom'
import style from '@/app/components/QuestionItem/style.scss'
import { Question } from '@/app/models/Question'
import words from '@/assets/strings'
import { paths } from '@/app/common/paths'

interface Props {
  readonly question: Question
  readonly isUserIdShow?: boolean
}

export const QuestionItem: FC<Props> = ({ question, isUserIdShow }: Props) => (
  <div>
    <h5 className={style.title}>
      <Link to={paths.question(question.id)}>{question.title}</Link>
    </h5>

    <div className={style.additional}>
      {isUserIdShow && (
        <>
          {words.common.by}
          <Link to={paths.user(question.userId)}>{question.userId}</Link>
        </>
      )}
      <hr className={style.hr} />
    </div>
  </div>
)
