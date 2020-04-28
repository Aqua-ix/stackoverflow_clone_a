import React, { FC } from 'react'
import { Link } from 'react-router-dom'
import { faSignInAlt, faUser } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import clsx from 'clsx'
import words from '@/assets/strings'
import style from '@/app/components/Header/style.scss'
import { paths } from '@/app/common/paths'

const isLoggedIn = (userId: string) => userId !== ''

interface LoginInfo {
  readonly userId: string
  readonly handleLogin: () => void
  readonly handleLogout: () => void
}

const HeaderButton: FC<LoginInfo> = ({ userId, handleLogin, handleLogout }: LoginInfo) =>
  isLoggedIn(userId) ? (
    <>
      <Link to={paths.user(userId)} className={clsx(style.navbarText, style.button)}>
        <FontAwesomeIcon className={style.icon} icon={faUser} />
      </Link>
      <button type="button" className={clsx(style.navbarText, style.button)} onClick={handleLogout}>
        <FontAwesomeIcon className={style.icon} icon={faSignInAlt} />
      </button>
    </>
  ) : (
    <button type="button" className={style.loginLink} onClick={handleLogin}>
      {words.header.login}
    </button>
  )

const isLoginInfo = (props: any): props is LoginInfo =>
  typeof props === 'object' &&
  typeof props?.userId === 'string' &&
  typeof props?.handleLogin === 'function' &&
  typeof props?.handleLogout === 'function'

type Props = LoginInfo | {}

export const Header: FC<Props> = (props: Props) => (
  <nav className={style.navbarDefault}>
    <Link to={paths.root} className={style.navbarBrand}>
      {words.header.title}
    </Link>
    <div className={style.formLine}>
      <div className={style.navbarText}>
        <span>
          {isLoginInfo(props) ? (
            <HeaderButton userId={props.userId} handleLogin={props.handleLogin} handleLogout={props.handleLogout} />
          ) : null}
        </span>
      </div>
    </div>
  </nav>
)
