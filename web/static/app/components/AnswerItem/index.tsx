import React, { FC, useState, useCallback, ChangeEvent } from 'react'
import { Link } from 'react-router-dom'
import clsx from 'clsx'
import style from '@/app/components/AnswerItem/style.scss'
import { Answer } from '@/app/models/Answer'
import words from '@/assets/strings'
import { paths } from '@/app/common/paths'
import { BODY_MAX_LENGTH, INPUT_MIN_LENGTH } from '@/app/common/constants'
import { getCurrentUserId } from '@/app/common/utils'

interface AnswerEditFormProps {
  readonly initialBody: string
  readonly updateAnswerBody: (text: string) => void
  readonly endAnswerEdit: () => void
}

const AnswerEditForm: FC<AnswerEditFormProps> = ({ initialBody, updateAnswerBody, endAnswerEdit }: AnswerEditFormProps) => {
  const [body, setBody] = useState(initialBody)

  const handleTextChange = (e: ChangeEvent<HTMLInputElement>) => setBody(e.target.value)
  const handleClickSave = () => {
    updateAnswerBody(body)
    endAnswerEdit()
  }

  return (
    <>
      {!body && <div className={style.errorEmpty}>{words.common.textErrorEmpty}</div>}
      <input
        maxLength={BODY_MAX_LENGTH}
        minLength={INPUT_MIN_LENGTH}
        required
        className={clsx(style.edit, style.formControl)}
        type="text"
        onChange={handleTextChange}
        value={body}
      />
      <div className={style.formGroup}>
        <button type="button" className={style.buttonSave} onClick={handleClickSave} disabled={!body}>
          {words.common.save}
        </button>
        <button type="button" className={style.buttonCancel} onClick={endAnswerEdit}>
          {words.common.cancel}
        </button>
      </div>
    </>
  )
}

interface AnswerItemViewProps {
  readonly answer: Answer
  readonly isMyAnswer: boolean
  readonly beginAnswerEdit: () => void
}

const AnswerItemView: FC<AnswerItemViewProps> = ({ answer, isMyAnswer, beginAnswerEdit }: AnswerItemViewProps) => (
  <>
    <div className={style.body}>{answer.body}</div>
    <div className={style.additional}>
      {`${words.common.additional(answer.createdAt)} ${words.common.by}`}
      <Link to={paths.user(answer.userId)}>{answer.userId}</Link>
      {isMyAnswer && (
        <span>
          <button type="button" className={style.buttonUpdate} onClick={beginAnswerEdit}>
            {words.common.update}
          </button>
        </span>
      )}
    </div>
  </>
)

interface AnswerItemProps {
  readonly answer: Answer
  readonly updateAnswer: (body: string, id: string) => void
}

export const AnswerItem: FC<AnswerItemProps> = ({ answer, updateAnswer }: AnswerItemProps) => {
  const [isEditAnswer, setIsEditAnswer] = useState(false)

  const currentUserId = getCurrentUserId()

  const beginAnswerEdit = useCallback(() => setIsEditAnswer(true), [])
  const endAnswerEdit = useCallback(() => setIsEditAnswer(false), [])

  const updateAnswerBody = useCallback((body: string) => updateAnswer(body, answer.id), [answer.id, updateAnswer])

  return (
    <>
      {isEditAnswer ? (
        <AnswerEditForm initialBody={answer.body} updateAnswerBody={updateAnswerBody} endAnswerEdit={endAnswerEdit} />
      ) : (
        <AnswerItemView answer={answer} isMyAnswer={currentUserId === answer.userId} beginAnswerEdit={beginAnswerEdit} />
      )}
      <hr className={style.hr} />
    </>
  )
}
