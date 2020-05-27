import { Book } from '@/app/models/Book'
import { Question } from '@/app/models/Question'
import { Answer } from '@/app/models/Answer'
import { Comment } from '@/app/models/Comment'
import { VoteType } from '@/app/models/Vote'
import { getSessionKey } from '@/app/common/utils'
import * as HttpClient from '@/app/common/http_client.ts'

export const retrieveBooks = (): Promise<Book[]> => HttpClient.get('/v1/book', {}).then(({ data }) => data)
export const retrieveBook = (id: string): Promise<Book> => HttpClient.get(`v1/book/${id}`, {}).then(({ data }) => data)
export const createBook = (title: string, author: string): Promise<Book> =>
  HttpClient.post(
    '/v1/book',
    {
      title,
      author,
    },
    {}
  ).then(({ data }) => data)
export const updateBook = (id: string, title: string, author: string): Promise<Book> =>
  HttpClient.put(
    `/v1/book/${id}`,
    {
      title,
      author,
    },
    {}
  ).then(({ data }) => data)

export const retrieveQuestionsByUser = (userId?: string): Promise<Question[]> =>
  HttpClient.get('/v1/question', { params: { userId } }).then(({ data }) => data)

  export const retrieveQuestionsByTag = (tags?: string): Promise<Question[]> =>
  HttpClient.get('/v1/question', { params: { tags } }).then(({ data }) => data)

export const retrieveQuestion = (id: string): Promise<Question> =>
  HttpClient.get(`v1/question/${id}`, {}).then(({ data }) => data)

export const createQuestion = (title: string, body: string, tags: string[]): Promise<Question> =>
  HttpClient.post(
    '/v1/question',
    {
      title,
      body,
      tags,
    },
    { headers: { Authorization: getSessionKey() } }
  ).then(({ data }) => data)

export const updateQuestion = (id: string, title: string, body: string, tags: string[]): Promise<Question> =>
  HttpClient.put(
    `/v1/question/${id}`,
    {
      title,
      body,
      tags,
    },
    { headers: { Authorization: getSessionKey() } }
  ).then(({ data }) => data)

export const createVote = (questionId: string, voteType: VoteType): Promise<Question> =>
  HttpClient.post(`/v1/question/${questionId}/vote/${voteType}`, {}, { headers: { Authorization: getSessionKey() } }).then(
    ({ data }) => data
  )

export const retrieveAnswers = ({ questionId, userId }: { questionId?: string; userId?: string }): Promise<Answer[]> =>
  HttpClient.get(`v1/answer`, {
    params: { questionId, userId },
  }).then(({ data }) => data)

export const createAnswer = (questionId: string, body: string): Promise<Answer[]> =>
  HttpClient.post(
    '/v1/answer',
    {
      questionId,
      body,
    },
    { headers: { Authorization: getSessionKey() } }
  ).then(({ data }) => data)

export const updateAnswer = (id: string, body: string): Promise<Answer[]> =>
  HttpClient.put(
    `/v1/answer/${id}`,
    {
      body,
    },
    { headers: { Authorization: getSessionKey() } }
  ).then(({ data }) => data)

export const createQuestionComment = (questionId: string, body: string): Promise<Comment> =>
  HttpClient.post(
    `/v1/question/${questionId}/comment`,
    {
      body,
    },
    { headers: { Authorization: getSessionKey() } }
  ).then(({ data }) => data)

export const updateQuestionComment = (questionId: string, id: string, body: string): Promise<Comment> =>
  HttpClient.put(
    `/v1/question/${questionId}/comment/${id}`,
    {
      body,
    },
    { headers: { Authorization: getSessionKey() } }
  ).then(({ data }) => data)

export const createAnswerComment = (answerId: string, body: string): Promise<Comment> =>
  HttpClient.post(
    `/v1/answer/${answerId}/comment`,
    {
      body,
    },
    { headers: { Authorization: getSessionKey() } }
  ).then(({ data }) => data)

export const updateAnswerComment = (answerId: string, id: string, body: string): Promise<Comment> =>
  HttpClient.put(
    `/v1/answer/${answerId}/comment/${id}`,
    {
      body,
    },
    { headers: { Authorization: getSessionKey() } }
  ).then(({ data }) => data)

export const login = (email: string, password: string): Promise<void> =>
  HttpClient.post(
    '/v1/user/login',
    {
      email,
      password,
    },
    {}
  ).then(
    ({
      data: {
        id,
        session: { key, expiresAt },
      },
    }: {
      data: { id: string; session: { key: string; expiresAt: string } }
    }) => {
      window.localStorage.setItem('sessionKey', key)
      window.localStorage.setItem('email', email)
      window.localStorage.setItem('id', id)
      window.localStorage.setItem('expiresAt', expiresAt)
      window.location.href = '/'
    }
  )

export const logout = () => {
  window.localStorage.removeItem('sessionKey')
  window.localStorage.removeItem('email')
  window.localStorage.removeItem('id')
  window.localStorage.removeItem('expiresAt')
  window.location.href = '/#login'
}
