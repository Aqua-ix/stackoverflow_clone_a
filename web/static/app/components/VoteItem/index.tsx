// import clsx from 'clsx'
import React, { FC } from 'react'
// import style from '@/app/components/VoteItem/style.scss'
import { Question as QuestionModels } from '@/app/models/Question'
import { VoteType } from '@/app/models/Vote'

interface Props {
  readonly userId: string
  readonly questionId: string
  readonly question: QuestionModels
  readonly likeVoterIds: string[]
  readonly dislikeVoterIds: string[]
  readonly createVote: (questionId: string, voteType: VoteType) => void
}

export const VoteItem: FC<Props> = ({ userId, questionId, question, likeVoterIds, dislikeVoterIds, createVote }: Props) => {
  console.log(userId, questionId, question, likeVoterIds, dislikeVoterIds, createVote)
  return (
    <div>
      {/* 現在の(like - dislike)の数を表示する */}
      {/* ▲マークを押したらcreateVote()を利用してlikeする */}
      {/* ▲マークを押したらcreateVote()を利用してdislikeする */}
    </div>
  )
}
