export const isValidEmail = (text: string) =>
  new RegExp(/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/).test(text)

export const isValidPassword = (text: string) => new RegExp(/^(?=.*?[a-z])(?=.*?[A-Z])[\x20-\x7e]*$/).test(text)
