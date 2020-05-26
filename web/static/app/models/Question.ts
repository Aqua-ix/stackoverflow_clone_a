import { Comment } from '@/app/models/Comment'

export interface Question {
  readonly body: string
  readonly comments: Comment[]
  readonly createdAt: string
  readonly dislikeVoterIds: string[]
  readonly id: string
  readonly likeVoterIds: string[]
  readonly title: string
  readonly userId: string
  tags:string[]
}
