import React, { FC, useReducer, ChangeEvent, FormEvent } from 'react'
import clsx from 'clsx'
import { initialState, reducer, actions } from '@/app/components/BookPost/reducer'
import style from '@/app/components/BookPost/style.scss'
import words from '@/assets/strings'
import { TITLE_MAX_LENGTH, BODY_MAX_LENGTH, INPUT_MIN_LENGTH } from '@/app/common/constants'

interface Props {
  readonly handleSubmit: (title: string, author: string) => void
}

export const BookPost: FC<Props> = ({ handleSubmit }: Props) => {
  const [state, dispatch] = useReducer(reducer, initialState)
  const { title, author } = state

  const handleTitleChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setTitle(e.target.value))
  const handleAuthorChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setAuthor(e.target.value))

  const handleClickSubmit = (e: FormEvent<HTMLFormElement>) => {
    handleSubmit(title, author)
    e.preventDefault()
  }

  return (
    <div className={style.main}>
      <div className={style.pageTitle}>{words.bookCreate.postBook}</div>
      <div className={style.label}>{words.bookCreate.title}</div>
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
        <div className={style.label}>{words.bookCreate.author}</div>
        <br />
        <input
          maxLength={BODY_MAX_LENGTH}
          minLength={INPUT_MIN_LENGTH}
          required
          className={clsx(style.authorEdit, style.formControl)}
          type="text"
          name="author"
          onChange={handleAuthorChange}
        />
        <br />
        <div className={style.formGroup}>
          <button type="submit" className={style.buttonPost}>
            {words.book.post}
          </button>
        </div>
      </form>
    </div>
  )
}
