import { CreateActionTypes } from '@/app/common/typeHelper'

interface State {
  body: string
  focused: boolean
}

const Type = {
  SET_BODY: 'SET_BODY',
  ON_FOCUS: 'ON_FOCUS',
  ON_BLUR: 'ON_BLUR',
  CLEAR_STATE: 'CLEAR_STATE',
} as const

export const actions = {
  setBody: (body: string) => ({ type: Type.SET_BODY, payload: body }),
  onFocus: () => ({ type: Type.ON_FOCUS }),
  onBlur: () => ({ type: Type.ON_BLUR }),
  clearState: () => ({ type: Type.CLEAR_STATE }),
}

type ActionType = CreateActionTypes<typeof actions>

export const initialState: State = {
  body: '',
  focused: false,
}

export const reducer = (state: State, action: ActionType): State => {
  switch (action.type) {
    case Type.SET_BODY:
      return { ...state, body: action.payload }

    case Type.ON_FOCUS:
      return { ...state, focused: true }

    case Type.ON_BLUR:
      return { ...state, focused: false }

    case Type.CLEAR_STATE:
      return initialState

    default:
      console.error(`unexpected action:${action}`)
      return state
  }
}
