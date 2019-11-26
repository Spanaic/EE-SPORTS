export default function ({ store, redirect }) {
    // ユーザーが認証されていないとき

    if (store.state.user.id === 0) {
        return redirect('/login')
    }
}