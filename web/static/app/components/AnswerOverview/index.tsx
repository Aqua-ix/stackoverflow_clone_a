import React, { FC } from 'react'
import { Link } from 'react-router-dom'
import style from '@/app/components/AnswerOverview/style.scss'
import { Answer } from '@/app/models/Answer'
import words from '@/assets/strings'
import { paths } from '@/app/common/paths'

interface Props {
  readonly answer: Answer
}

export const AnswerOverview: FC<Props> = ({ answer }: Props) => (
  <div>
    <h5 className={style.title}>
      <Link to={paths.question(answer.questionId)}>{answer.body}</Link>
    </h5>
    <div className={style.additional}>{words.common.additional(answer.createdAt)}</div>
    <hr className={style.hr} />
  </div>
)
