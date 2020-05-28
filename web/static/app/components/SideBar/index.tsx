import React, { FC } from 'react'
import style from '@/app/components/SideBar/style.scss'
import { Link } from 'react-router-dom'
import { paths } from '@/app/common/paths'
import words from '@/assets/strings'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faHome, faUser } from '@fortawesome/free-solid-svg-icons'


interface LoginInfo {
  readonly userId: string
  readonly handleLogin: () => void
  readonly handleLogout: () => void
}

type Props = LoginInfo | {}

export const SideBar: FC<Props> = (props: Props) => (
  <div className={style.sidebar}>
    <div className={style.sidebar_item_fixed}>
      <ul>
        <li className={style.sidebar_list}>
          <FontAwesomeIcon className={style.icon} icon={faHome} />
          <Link to={paths.root}>{words.sidebar.home}</Link>
        </li>
        <li className={style.sidebar_list}>
          <FontAwesomeIcon className={style.icon} icon={faUser} />
          <Link to={paths.userList}>{words.sidebar.users}</Link>
        </li>
      </ul>
    </div>
  </div>
)
