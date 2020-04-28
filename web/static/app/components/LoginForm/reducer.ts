import { CreateActionTypes } from '@/app/common/typeHelper'
import { isValidEmail, isValidPassword } from '@/app/common/validator'

interface State {
  email: string
  password: string
  isValidEmail: boolean
  isValidPassword: boolean
}

const Type = {
  SET_EMAIL: 'SET_EMAIL',
  SET_PASSWORD: 'SET_PASSWORD',
} as const

export const actions = {
  setEmail: (email: string) => ({ type: Type.SET_EMAIL, payload: email }),
  setPassword: (password: string) => ({ type: Type.SET_PASSWORD, payload: password }),
}

type ActionType = CreateActionTypes<typeof actions>

export const initialState: State = {
  email: '',
  password: '',
  isValidEmail: false,
  isValidPassword: false,
}

export const reducer = (state: State, action: ActionType): State => {
  switch (action.type) {
    case Type.SET_EMAIL:
      return { ...state, email: action.payload, isValidEmail: isValidEmail(action.payload) }

    case Type.SET_PASSWORD:
      return { ...state, password: action.payload, isValidPassword: isValidPassword(action.payload) }

    default:
      console.error(`unexpected action:${action}`)
      return state
  }
}
