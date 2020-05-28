import React, { FC } from 'react'
import { Link } from 'react-router-dom'
import style from '@/app/components/QuestionItem/style.scss'
import { Question } from '@/app/models/Question'
import words from '@/assets/strings'
import { paths } from '@/app/common/paths'
import { getTimeString, getUserName } from '@/app/common/utils'

interface Props {
  readonly question: Question
  readonly isUserIdShow?: boolean
}

export const QuestionItem: FC<Props> = ({ question, isUserIdShow }: Props) => (
  <div>
    <h5 className={style.title}>
      <Link to={paths.question(question.id)}>{question.title}</Link>
    </h5>
    <div className={style.bodytext}>{question.body}</div>
    <div className={style.taggroup}>
      {question.tags[0]
        ? question.tags.map((tag: string) => (
            <span>
              {' '}
              <Link to={paths.tag(tag)}>
                <button type="button" className={style.button}>
                  {tag}
                </button>
              </Link>{' '}
            </span>
          ))
        : null}
    </div>

    <div className={style.additional}>
      {`${getTimeString(question.createdAt)} `}
      {isUserIdShow && (
        <>
          {words.common.by}
          <Link to={paths.user(question.userId)}>{getUserName(question.userId)}</Link>
        </>
      )}
      <hr className={style.hr} />
    </div>
  </div>
)
