import React, { FC, useState, useCallback, ChangeEvent } from 'react'
import { Link } from 'react-router-dom'
import clsx from 'clsx'
import style from '@/app/components/CommentItem/style.scss'
import { Comment } from '@/app/models/Comment'
import words from '@/assets/strings'
import { paths } from '@/app/common/paths'
import { getTimeString, getUserName } from '@/app/common/utils'
import { BODY_MAX_LENGTH, INPUT_MIN_LENGTH } from '@/app/common/constants'
import marked from 'marked'

interface CommentEditFormProps {
  readonly initialBody: string
  readonly updateCommentBody: (text: string) => void
  readonly endCommentEdit: () => void
}

const CommentEditForm: FC<CommentEditFormProps> = ({ initialBody, updateCommentBody, endCommentEdit }: CommentEditFormProps) => {
  const [body, setBody] = useState(initialBody)

  const handleTextChange = (e: ChangeEvent<HTMLInputElement>) => setBody(e.target.value)
  const handleClickSave = () => {
    updateCommentBody(body)
    endCommentEdit()
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
        <button type="button" className={style.buttonCancel} onClick={endCommentEdit}>
          {words.common.cancel}
        </button>
      </div>
    </>
  )
}

interface CommentItemViewProps {
  readonly comment: Comment
  readonly isMyComment: boolean
  readonly beginCommentEdit: () => void
}

const CommentItemView: FC<CommentItemViewProps> = ({ comment, isMyComment, beginCommentEdit }: CommentItemViewProps) => (
  <>
    <span className={style.body}>
      <div
        dangerouslySetInnerHTML={{
          __html: marked(comment.body),
        }}
      />
    </span>
    <span className={style.additional}>
      {`${words.common.hyphen} ${getTimeString(comment.createdAt)} ${words.common.by}`}
      <Link to={paths.user(comment.userId)}>{getUserName(comment.userId)}</Link>
      {isMyComment && (
        <span>
          <button type="button" className={style.buttonUpdate} onClick={beginCommentEdit}>
            {words.common.update}
          </button>
        </span>
      )}
    </span>
  </>
)

interface CommentItemProps {
  readonly comment: Comment
  readonly userId: string
  readonly updateComment: (body: string) => void
}

export const CommentItem: FC<CommentItemProps> = ({ comment, userId, updateComment }: CommentItemProps) => {
  const [isEditComment, setIsEditComment] = useState<boolean>(false)

  const updateCommentBody = useCallback((body: string) => updateComment(body), [updateComment])
  const beginCommentEdit = useCallback(() => setIsEditComment(true), [])
  const endCommentEdit = useCallback(() => setIsEditComment(false), [])

  return (
    <div className={style.main}>
      {isEditComment ? (
        <CommentEditForm initialBody={comment.body} updateCommentBody={updateCommentBody} endCommentEdit={endCommentEdit} />
      ) : (
        <CommentItemView comment={comment} isMyComment={userId === comment.userId} beginCommentEdit={beginCommentEdit} />
      )}
      <hr className={style.hr} />
    </div>
  )
}
