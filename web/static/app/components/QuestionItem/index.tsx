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

const getTermString = (date: string) => {
  const templateString: string = '質問日時: '
  const nowTime = Date.now()
  const res = new Date(nowTime - Date.parse(date) - 9 * 60 * 60 * 1000)
  if (res.getFullYear() - 1970 !== 0) {
    return templateString + (res.getFullYear() - 1970) + '年前 '
  } else if (res.getMonth() !== 0) {
    return templateString + res.getMonth() + 'ヶ月前 '
  } else if (res.getDate() - 1 !== 0) {
    return templateString + res.getDate() + '日前 '
  } else if (res.getHours() !== 0) {
    return templateString + res.getHours() + '時間前 '
  } else {
    return templateString + res.getMinutes() + '分前 '
  }
}

const getDisplayName = (userId: string) => {
  switch (userId) {
    case '5ea7da5f83bdd64c5754b97f':
      return 'ユーザー1'
    case '5ea7da5fefbd276f270f93e6':
      return 'ユーザー2'
    default:
      return 'その他のユーザー'
  }
}

export const QuestionItem: FC<Props> = ({ question, isUserIdShow }: Props) => (
  <div>
    <h5 className={style.title}>
      <Link to={paths.question(question.id)}>{question.title}</Link>
    </h5>
    <div className={style.bodytext}>
      　{question.body}
    </div>
    <div className={style.taggroup}>
      {question.tags[0] ? question.tags.map((tag:string) =>
        <span>
          <Link to={paths.tag(tag)}>
            <button　className={style.button}>
                {tag}
            </button>
          </Link>
        </span>
      ): null}
    </div>

    <div className={style.additional}>
      {getTermString(question.createdAt) + ' '}
      {isUserIdShow && (
        <>
          {words.common.by}
          <Link to={paths.user(question.userId)}>{getDisplayName(question.userId)}</Link>
        </>
      )}
      <hr className={style.hr} />
    </div>
  </div>
)
