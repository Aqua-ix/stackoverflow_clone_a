import { CreateActionTypes } from '@/app/common/typeHelper'

interface State {
  title: string
  author: string
}

const Type = {
  SET_TITLE: 'SET_TITLE',
  SET_AUTHOR: 'SET_AUTHOR',
} as const

export const actions = {
  setTitle: (title: string) => ({ type: Type.SET_TITLE, payload: title }),
  setAuthor: (author: string) => ({ type: Type.SET_AUTHOR, payload: author }),
}

type ActionType = CreateActionTypes<typeof actions>

export const initialState: State = {
  title: '',
  author: '',
}

export const reducer = (state: State, action: ActionType): State => {
  switch (action.type) {
    case Type.SET_TITLE:
      return { ...state, title: action.payload }

    case Type.SET_AUTHOR:
      return { ...state, author: action.payload }

    default:
      console.error(`unexpected action:${action}`)
      return state
  }
}
