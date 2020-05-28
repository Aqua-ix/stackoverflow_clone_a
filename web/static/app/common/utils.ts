export const getCurrentUserId = () => window.localStorage.getItem('id') || ''

export const getSessionKey = () => window.localStorage.getItem('sessionKey') || ''

export const getTimeString = (date: string) => {
    const d = new Date(Date.parse(date))
    return `${d.getFullYear()}年${d.getMonth()}月${d.getDay()}日 ${d.getHours()}:${d.getMinutes()}`
  }
  
export const getUserName = (userId: string) => {
    switch (userId) {
        case '5ea7da5f83bdd64c5754b97f':
        return 'ユーザー1'
        case '5ea7da5fefbd276f270f93e6':
        return 'ユーザー2'
        default:
        return 'その他のユーザー'
    }
}
