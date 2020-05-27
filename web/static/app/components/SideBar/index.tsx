import React, { FC } from 'react'
import style from '@/app/components/SideBar/style.scss'
import { Link } from 'react-router-dom'
import { paths } from '@/app/common/paths'
import words from '@/assets/strings'

interface LoginInfo {
  readonly userId: string
  readonly handleLogin: () => void
  readonly handleLogout: () => void
}

type Props = LoginInfo | {}

export const SideBar: FC<Props> = (props: Props) => (
  <div className = {style.sidebar}> 
    <div className = {style.sidebar_item_fixed}>
      <li className = {style.sidebar_list}>
        <Link to={paths.root}>{words.sidebar.home}</Link>
        </li>
      <li className = {style.sidebar_list}>タグ一覧</li>
      <li className = {style.sidebar_list}>{words.sidebar.unsolved}</li>
    </div>
  </div>
)
