import React, { FC } from 'react'
import { Link } from 'react-router-dom'
import style from '@/app/components/BookItem/style.scss'
import { Book } from '@/app/models/Book'
import { paths } from '@/app/common/paths'

interface Props {
  readonly book: Book
}

export const BookItem: FC<Props> = ({ book }: Props) => (
  <div>
    <h5 className={style.title}>
      <Link to={paths.book(book.id)}>{book.title}</Link>
    </h5>
    <hr className={style.hr} />
  </div>
)
