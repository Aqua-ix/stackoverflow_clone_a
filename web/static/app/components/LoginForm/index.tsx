import React, { FC, useReducer, ChangeEvent, FormEvent } from 'react'

import { initialState, reducer, actions } from '@/app/components/LoginForm/reducer'
import style from '@/app/components/LoginForm/style.scss'

import words from '@/assets/strings'

interface Props {
  readonly login: (email: string, password: string) => void
}

export const LoginForm: FC<Props> = ({ login }: Props) => {
  const [state, dispatch] = useReducer(reducer, initialState)
  const { email, password, isValidEmail, isValidPassword } = state

  const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
    login(email, password)
    e.preventDefault()
  }
  const handleEmailChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setEmail(e.target.value))
  const handlePasswordChange = (e: ChangeEvent<HTMLInputElement>) => dispatch(actions.setPassword(e.target.value))

  return (
    <form className={style.main} onSubmit={handleSubmit}>
      <div className={style.marginLeft}>
        <label className={style.label}>{words.login.id}</label>
        <div className={style.errorLabel}>{email ? !isValidEmail && words.login.idErrorInvalid : words.login.idErrorEmpty}</div>
        <input
          className={style.input}
          type="email"
          name="email"
          placeholder={words.login.idPlaceholder}
          onChange={handleEmailChange}
        />

        <label className={style.label}>{words.login.password}</label>
        <div className={style.errorLabel}>
          {password ? !isValidPassword && words.login.passwordErrorInvalid : words.login.passwordErrorEmpty}
        </div>
        <input
          className={style.input}
          type="password"
          name="password"
          autoComplete="new-password"
          placeholder={words.login.passwordPlaceholder}
          onChange={handlePasswordChange}
        />

        <button type="submit" className={style.loginButton} disabled={!(isValidEmail && isValidPassword)}>
          {words.login.login}
        </button>
      </div>
    </form>
  )
}
