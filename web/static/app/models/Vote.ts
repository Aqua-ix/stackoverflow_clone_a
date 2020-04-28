export type VoteType = 'like_vote' | 'dislike_vote'

export interface VoteState {
  readonly likeVoterIds: string[]
  readonly dislikeVoterIds: string[]
}
