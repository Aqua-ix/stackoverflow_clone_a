import React, { FC, useReducer, ChangeEvent, FormEvent } from 'react'
import clsx from 'clsx'
import { initialState, reducer, actions } from '@/app/components/QuestionPost/reducer'
import style from '@/app/components/QuestionPost/style.scss'
import words from '@/assets/strings'
import { TITLE_MAX_LENGTH, TAG_MAX_LENGTH, BODY_MAX_LENGTH, INPUT_MIN_LENGTH } from '@/app/common/constants'
import { getCurrentUserId } from '@/app/common/utils'
import marked from 'marked'

interface Props {
  readonly handleSubmit: (title: string, body: string, tags: string[]) => void
}

export const QuestionPost: FC<Props> = ({ handleSubmit }: Props) => {
  const [state, dispatch] = useReducer(reducer, initialState)
  const { title, body, tags } = state

  const handleTitleChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setTitle(e.target.value))
  const handleBodyChange = (e: ChangeEvent<HTMLTextAreaElement>) => dispatch(actions.setBody(e.target.value))
  const handleTagChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setTags(e.target.value.split(',')))

  const handleClickSubmit = (e: FormEvent<HTMLFormElement>) => {
    handleSubmit(title, body, tags)
    e.preventDefault()
  }

  const currentUserId = getCurrentUserId()

  return (
    <div className={style.main}>
      <div className={style.pageTitle}>{words.questionCreate.postQuestion}</div>
      {currentUserId ? (
        <>
          <div className={style.label}>{words.questionCreate.title}</div>
          <br />
          <form onSubmit={handleClickSubmit}>
            <input
              maxLength={TITLE_MAX_LENGTH}
              minLength={INPUT_MIN_LENGTH}
              required
              className={clsx(style.titleEdit, style.formControl)}
              type="text"
              name="title"
              onChange={handleTitleChange}
            />
            <br />
            <div className={style.label}>{words.questionCreate.body}</div>
            <br />
            <textarea
              maxLength={BODY_MAX_LENGTH}
              minLength={INPUT_MIN_LENGTH}
              required
              className={clsx(style.bodyEdit, style.formControl)}
              name="body"
              onChange={handleBodyChange}
            />
            <div
              dangerouslySetInnerHTML={{
                __html: marked(body),
              }}
            />
            <br />
            <div className={style.label}>{words.questionCreate.tag}</div>
            <br />
            <input
              maxLength={TAG_MAX_LENGTH}
              minLength={INPUT_MIN_LENGTH}
              className={clsx(style.tagEdit, style.formControl)}
              type="text"
              name="tags"
              onChange={handleTagChange}
            />
            <br />
            <div className={style.formGroup}>
              <button type="submit" className={style.buttonPost}>
                {words.question.post}
              </button>
            </div>
          </form>
        </>
      ) : (
        <>{words.questionCreate.notLoginBody}</>
      )}
    </div>
  )
}
