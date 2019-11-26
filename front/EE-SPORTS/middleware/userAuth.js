export default function ({ store, redirect, route }) {
    // 現在のユーザーとリクエストされたユーザーが食い違う場合
    if (parseInt(route.params.userId) !== store.state.user.id) {
        return redirect(`/end_users/${store.state.user.id}`)
    }
}