export const validateEmail = validate => {
    let errors = []
    if (!validate.$dirty) return errors
    !validate.required && errors.push('メールアドレスを入力してください')
    !validate.email && errors.push('メールアドレスの形式で入力してください')
    return errors
}

export const validatePassword = validate => {
    let errors = []
    if (!validate.$dirty) return errors
    !validate.required && errors.push('パスワードを入力してください')
    return errors
}