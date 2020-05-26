import { CreateActionTypes } from '@/app/common/typeHelper'

interface State {
  title: string
  body: string
  tags: string
}

const Type = {
  SET_TITLE: 'SET_TITLE',
  SET_BODY: 'SET_BODY',
  SET_TAGS: 'SET_TAGS',
} as const

export const actions = {
  setTitle: (title: string) => ({ type: Type.SET_TITLE, payload: title }),
  setBody: (body: string) => ({ type: Type.SET_BODY, payload: body }),
  setTags: (tags: string) => ({ type: Type.SET_TAGS, payload: tags }),
}

type ActionType = CreateActionTypes<typeof actions>

export const initialState: State = {
  title: '',
  body: '',
  tags: '',
}

export const reducer = (state: State, action: ActionType): State => {
  switch (action.type) {
    case Type.SET_TITLE:
      return { ...state, title: action.payload }

    case Type.SET_BODY:
      return { ...state, body: action.payload }
  
    case Type.SET_TAGS:
      return { ...state, tags: action.payload }

    default:
      console.error(`unexpected action:${action}`)
      return state
  }
}
