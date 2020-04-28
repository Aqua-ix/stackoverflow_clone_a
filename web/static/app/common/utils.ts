export const getCurrentUserId = () => window.localStorage.getItem('id') || ''

export const getSessionKey = () => window.localStorage.getItem('sessionKey') || ''
