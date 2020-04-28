import React, { FC, useState, useReducer, useCallback, ChangeEvent } from 'react'
import clsx from 'clsx'
import { reducer, actions } from '@/app/components/BookDetail/Book/reducer'
import style from '@/app/components/BookDetail/Book/style.scss'
import { Book as BookModels } from '@/app/models/Book'
import words from '@/assets/strings'
import { INPUT_MIN_LENGTH, AUTHOR_MAX_LENGTH } from '@/app/common/constants'

interface BookEditFormProps {
  book: BookModels
  endBookEdit: () => void
  updateBook: (title: string, author: string) => void
}

const BookEditForm: FC<BookEditFormProps> = ({ book, endBookEdit, updateBook }: BookEditFormProps) => {
  const [state, dispatch] = useReducer(reducer, {
    title: book.title,
    author: book.author,
  })
  const { title, author } = state

  const handleTitleChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setTitle(e.target.value))
  const handleBodyChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setAuthor(e.target.value))
  const handleSaveClick = () => {
    updateBook(title, author)
    endBookEdit()
  }

  return (
    <>
      {!title && <div className={style.errorEmpty}>{words.common.textErrorEmpty}</div>}
      <input
        maxLength={AUTHOR_MAX_LENGTH}
        minLength={INPUT_MIN_LENGTH}
        required
        className={clsx(style.titleEdit, style.formControl)}
        type="text"
        onChange={handleTitleChange}
        value={title}
      />

      <hr className={style.hr} />
      <div className={style.mainArea}>
        <div className={style.contentArea}>
          {!author && <div className={style.errorEmpty}>{words.common.textErrorEmpty}</div>}
          <input
            maxLength={AUTHOR_MAX_LENGTH}
            minLength={INPUT_MIN_LENGTH}
            required
            className={clsx(style.authorEdit, style.formControl)}
            type="text"
            onChange={handleBodyChange}
            value={author}
          />
          <div className={style.formGroup}>
            <button type="button" className={style.buttonSave} onClick={handleSaveClick} disabled={!title || !author}>
              {words.common.save}
            </button>
            <button type="button" className={style.buttonCancel} onClick={endBookEdit}>
              {words.common.cancel}
            </button>
          </div>
        </div>
      </div>
    </>
  )
}

interface BookViewProps {
  book: BookModels
  beginBookEdit: () => void
}

const BookView: FC<BookViewProps> = ({ book, beginBookEdit }: BookViewProps) => (
  <>
    <div className={style.pageTitle}>{book.title}</div>
    <hr className={style.hr} />
    <div className={style.mainArea}>
      <div className={style.contentArea}>
        <div className={style.author}>{book.author}</div>
        <div className={style.additional}>
          <span>
            <button type="button" className={style.buttonUpdate} onClick={beginBookEdit}>
              {words.common.update}
            </button>
          </span>
        </div>
      </div>
    </div>
  </>
)

interface BookProps {
  readonly bookId: string
  readonly book: BookModels
  readonly updateBook: (title: string, author: string, bookId: string) => void
}

export const Book: FC<BookProps> = ({ bookId, book, updateBook }: BookProps) => {
  const [isEditBook, setIsEditBook] = useState<boolean>(false)

  const updateBookBody = useCallback((title: string, author: string) => updateBook(title, author, bookId), [bookId, updateBook])

  const beginBookEdit = useCallback(() => setIsEditBook(true), [])
  const endBookEdit = useCallback(() => setIsEditBook(false), [])

  return (
    <div className={style.book}>
      {isEditBook ? (
        <BookEditForm book={book} endBookEdit={endBookEdit} updateBook={updateBookBody} />
      ) : (
        <BookView book={book} beginBookEdit={beginBookEdit} />
      )}
    </div>
  )
}
