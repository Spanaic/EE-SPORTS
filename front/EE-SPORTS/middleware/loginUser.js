export default function ({ store, redirect, route }) {
    // ログイン済みユーザーをredirectさせるmiddleware

    if (store.state.user.id !== 0) {
        return redirect('/post_Images')
    }
}