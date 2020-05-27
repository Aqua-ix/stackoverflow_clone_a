import React, { FC, useState, useReducer, useCallback, ReactNode, ChangeEvent } from 'react'
import { Link } from 'react-router-dom'
import clsx from 'clsx'
import { reducer, actions } from '@/app/components/QuestionDetail/Question/reducer'
import { VoteItem } from '@/app/components/VoteItem'
import style from '@/app/components/QuestionDetail/Question/style.scss'
import { Question as QuestionModels } from '@/app/models/Question'
import { Comment } from '@/app/models/Comment'
import { VoteType } from '@/app/models/Vote'
import words from '@/assets/strings'
import { paths } from '@/app/common/paths'
import { CommentItem } from '@/app/components/CommentItem'
import { CommentPost } from '@/app/components/CommentPost'
import { INPUT_MIN_LENGTH, BODY_MAX_LENGTH } from '@/app/common/constants'

interface QuestionEditFormProps {
  question: QuestionModels
  children: ReactNode
  endQuestionEdit: () => void
  updateQuestion: (title: string, body: string, tags: string[]) => void
}

const QuestionEditForm: FC<QuestionEditFormProps> = ({
  question,
  children,
  endQuestionEdit,
  updateQuestion,
}: QuestionEditFormProps) => {
  const [state, dispatch] = useReducer(reducer, {
    title: question.title,
    body: question.body,
    tags: question.tags,
  })
  const { title, body, tags } = state

  const handleTitleChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setTitle(e.target.value))
  const handleBodyChange = (e: ChangeEvent<HTMLTextAreaElement>) => dispatch(actions.setBody(e.target.value))
  const handleTagChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setTags(e.target.value.split(',')))
  const handleSaveClick = () => {
    updateQuestion(title, body, tags)
    endQuestionEdit()
  }

  return (
    <>
      {!title && <div className={style.errorEmpty}>{words.common.textErrorEmpty}</div>}
      {words.questionCreate.title}
      <input
        maxLength={BODY_MAX_LENGTH}
        minLength={INPUT_MIN_LENGTH}
        required
        className={clsx(style.titleEdit, style.formControl)}
        type="text"
        onChange={handleTitleChange}
        value={title}
      />
      {words.questionCreate.tag}
      <input
        maxLength={BODY_MAX_LENGTH}
        minLength={INPUT_MIN_LENGTH}
        className={clsx(style.tagEdit, style.formControl)}
        type="text"
        name="tags"
        onChange={handleTagChange}
        value={tags}
      />

      <hr className={style.hr} />
      <div className={style.mainArea}>
        {words.questionCreate.body}
        {children}
        <div className={style.contentArea}>
          {!body && <div className={style.errorEmpty}>{words.common.textErrorEmpty}</div>}
          <textarea
            maxLength={BODY_MAX_LENGTH}
            minLength={INPUT_MIN_LENGTH}
            required
            className={clsx(style.bodyEdit, style.formControl)}
            onChange={handleBodyChange}
            value={body}
          />
          <div className={style.formGroup}>
            <button type="button" className={style.buttonSave} onClick={handleSaveClick} disabled={!title || !body || !tags}>
              {words.common.save}
            </button>
            <button type="button" className={style.buttonCancel} onClick={endQuestionEdit}>
              {words.common.cancel}
            </button>
          </div>
        </div>
      </div>
    </>
  )
}

interface QuestionViewProps {
  children: ReactNode
  question: QuestionModels
  isMyQuestion: boolean
  beginQuestionEdit: () => void
}

const QuestionView: FC<QuestionViewProps> = ({ children, question, isMyQuestion, beginQuestionEdit }: QuestionViewProps) => (
  <>
    <div className={style.pageTitle}>{question.title}</div>
    <div className={style.taggroup}>
      {question.tags[0]
        ? question.tags.map((tag: string) => (
            <span>
              {' '}
              <button type="button" className={style.button}>
                {tag}
              </button>{' '}
            </span>
          ))
        : null}
    </div>
    <hr className={style.hr} />
    <div className={style.mainArea}>
      {children}
      <div className={style.contentArea}>
        <div className={style.body}>{question.body}</div>
        <div className={style.additional}>
          {`${words.common.additional(question.createdAt)} ${words.common.by}`}
          <Link to={paths.user(question.userId)}>{question.userId}</Link>
          {isMyQuestion && (
            <span>
              <button type="button" className={style.buttonUpdate} onClick={beginQuestionEdit}>
                {words.common.update}
              </button>
            </span>
          )}
        </div>
      </div>
    </div>
  </>
)

interface VoteFormProps {
  readonly userId: string
  readonly question: QuestionModels
  readonly createVote: (questionId: string, voteType: VoteType) => void
}

const VoteForm: FC<VoteFormProps> = ({ userId, question, createVote }: VoteFormProps) => (
  <div className={style.infoArea}>
    <VoteItem
      userId={userId}
      questionId={question.id}
      question={question}
      likeVoterIds={question.likeVoterIds}
      dislikeVoterIds={question.dislikeVoterIds}
      createVote={createVote}
    />
  </div>
)

interface QuestionProps {
  readonly userId: string
  readonly questionId: string
  readonly question: QuestionModels
  readonly updateQuestion: (title: string, body: string, questionId: string, tags: string[]) => void
  readonly createQuestionComment: (body: string, questionId: string) => void
  readonly updateQuestionComment: (body: string, questionId: string, id: string) => void
  readonly createVote: (questionId: string, voteType: VoteType) => void
}

export const Question: FC<QuestionProps> = ({
  userId,
  questionId,
  question,
  updateQuestion,
  createQuestionComment,
  updateQuestionComment,
  createVote,
}: QuestionProps) => {
  const [isEditQuestion, setIsEditQuestion] = useState<boolean>(false)

  const updateComment = (commentId: string) => (body: string) => updateQuestionComment(body, questionId, commentId)
  const createComment = (body: string) => createQuestionComment(body, questionId)

  const updateQuestionBody = useCallback(
    (title: string, body: string, tags: string[]) => updateQuestion(title, body, questionId, tags),
    [questionId, updateQuestion]
  )

  const beginQuestionEdit = useCallback(() => setIsEditQuestion(true), [])
  const endQuestionEdit = useCallback(() => setIsEditQuestion(false), [])

  return (
    <div className={style.question}>
      {isEditQuestion ? (
        <QuestionEditForm question={question} endQuestionEdit={endQuestionEdit} updateQuestion={updateQuestionBody}>
          <VoteForm userId={userId} question={question} createVote={createVote} />
        </QuestionEditForm>
      ) : (
        <QuestionView question={question} isMyQuestion={userId === question.userId} beginQuestionEdit={beginQuestionEdit}>
          <VoteForm userId={userId} question={question} createVote={createVote} />
        </QuestionView>
      )}

      <hr className={style.hr} />
      {question.comments.map((comment: Comment) => (
        <CommentItem
          key={`${comment.body}_${comment.id}`}
          comment={comment}
          userId={userId}
          updateComment={updateComment(comment.id)}
        />
      ))}
      <CommentPost userId={userId} createComment={createComment} />
    </div>
  )
}
