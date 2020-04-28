import React, { FC, useReducer, ChangeEvent } from 'react'
import clsx from 'clsx'
import { reducer, initialState, actions } from '@/app/components/AnswerPost/reducer'
import style from '@/app/components/CommentPost/style.scss'
import words from '@/assets/strings'
import { BODY_MAX_LENGTH, INPUT_MIN_LENGTH } from '@/app/common/constants'

interface Props {
  readonly userId: string
  readonly createComment: (body: string) => void
}

export const CommentPost: FC<Props> = ({ userId, createComment }: Props) => {
  const [state, dispatch] = useReducer(reducer, initialState)
  const { body, focused } = state

  const handleTextChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setBody(e.target.value))
  const handlePostClick = () => {
    createComment(body)
    dispatch(actions.clearState())
  }
  const onFocusInput = () => dispatch(actions.onFocus())
  const onBlurInput = () => dispatch(actions.onBlur())

  // NOTE: 未ログイン時はコメントできない
  if (!userId) {
    return <div className={style.commentList}>{words.question.loginToComment}</div>
  }

  return (
    <>
      <div className={style.title}>{words.question.commentAdd}</div>
      {!body && focused && <div className={style.errorEmpty}>{words.common.textErrorEmpty}</div>}
      <input
        maxLength={BODY_MAX_LENGTH}
        minLength={INPUT_MIN_LENGTH}
        required
        className={clsx(style.edit, style.formControl)}
        type="text"
        onChange={handleTextChange}
        onFocus={onFocusInput}
        onBlur={onBlurInput}
        value={body}
      />
      <div className={style.formGroup}>
        <button type="button" className={style.buttonPost} onClick={handlePostClick} disabled={!body}>
          {words.question.post}
        </button>
      </div>
    </>
  )
}
