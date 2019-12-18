export default function ({ store, redirect, route }) {
    // 未ログインのユーザーをredirectさせる

    if (store.state.user.id === 0) {
        return redirect('/login')
    }
}