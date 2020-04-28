import React, { FC, useReducer, ChangeEvent } from 'react'
import clsx from 'clsx'
import { reducer, initialState, actions } from '@/app/components/AnswerPost/reducer'
import style from '@/app/components/AnswerPost/style.scss'
import words from '@/assets/strings'
import { BODY_MAX_LENGTH, INPUT_MIN_LENGTH } from '@/app/common/constants'

interface Props {
  readonly userId: string
  readonly postAnswer: (body: string) => void
}

export const AnswerPost: FC<Props> = ({ userId, postAnswer }: Props) => {
  const [state, dispatch] = useReducer(reducer, initialState)
  const { body, focused } = state

  const handleTextChange = (e: ChangeEvent<HTMLTextAreaElement>) => dispatch(actions.setBody(e.target.value))
  const handlePostClick = () => {
    postAnswer(body)
    dispatch(actions.clearState())
  }
  const onFocusTextArea = () => dispatch(actions.onFocus())
  const onBlurTextArea = () => dispatch(actions.onBlur())

  return (
    <div className={style.main}>
      <div className={style.title}>{words.question.answer}</div>
      <hr className={style.hr} />

      {userId ? (
        <>
          {!body && focused && <div className={style.errorEmpty}>{words.common.textErrorEmpty}</div>}
          <form>
            <textarea
              maxLength={BODY_MAX_LENGTH}
              minLength={INPUT_MIN_LENGTH}
              required
              className={clsx(style.edit, style.formControl)}
              onChange={handleTextChange}
              onFocus={onFocusTextArea}
              onBlur={onBlurTextArea}
              value={body}
            />
            <div className={style.formGroup}>
              <button type="button" className={style.buttonPost} onClick={handlePostClick} disabled={!body}>
                {words.question.post}
              </button>
            </div>
          </form>
        </>
      ) : (
        <>{words.question.loginToAnswer}</>
      )}
    </div>
  )
}
