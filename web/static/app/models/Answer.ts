import { Comment } from '@/app/models/Comment'

export interface Answer {
  readonly id: string
  readonly body: string
  readonly questionId: string
  readonly userId: string
  readonly createdAt: string
  readonly comments: Comment[]
}
