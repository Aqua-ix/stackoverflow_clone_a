import React, { FC } from 'react'

import { Header } from '@/app/components/Header'
import { LoginForm } from '@/app/components/LoginForm'
import { Footer } from '@/app/components/Footer'
import { login } from '@/app/common/api'

const LoginPage: FC = () => (
  <>
    <Header />
    <LoginForm login={login} />
    <Footer />
  </>
)

export default LoginPage
