import React from 'react'
import ReactDOM from 'react-dom'
import { HashRouter, Switch, Route } from 'react-router-dom'

import QuestionListPage from '@/app/pages/QuestionListPage'
import LoginPage from '@/app/pages/LoginPage'
import UserDetailPage from '@/app/pages/UserDetailPage'
import QuestionCreatePage from '@/app/pages/QuestionCreatePage'
import QuestionDetailPage from '@/app/pages/QuestionDetailPage'
import TagFilterPage from '@/app/pages/TagFilterPage'

import BookListPage from '@/app/pages/BookListPage'
import BookDetailPage from '@/app/pages/BookDetailPage'
import BookCreatePage from '@/app/pages/BookCreatePage'

import { paths } from '@/app/common/paths'
import '@/assets/css/reboot.css'
import '@/assets/css/common.scss'

ReactDOM.render(
  <HashRouter>
    <Switch>
      <Route path={paths.login} component={LoginPage} />
      <Route path={paths.user()} component={UserDetailPage} />
      <Route path={paths.questionCreate} component={QuestionCreatePage} />
      <Route path={paths.question()} component={QuestionDetailPage} />
      <Route path={paths.tag()} component={TagFilterPage} />
      <Route path={paths.bookCreate} component={BookCreatePage} />
      <Route path={paths.book()} component={BookDetailPage} />
      <Route path={paths.bookList} component={BookListPage} />
      <Route path={paths.root} component={QuestionListPage} />
      <Route render={() => <h1>404 Not Found</h1>} />
    </Switch>
  </HashRouter>,
  document.getElementById('root')
)
