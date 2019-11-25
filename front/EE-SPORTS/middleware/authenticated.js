export default function ({ store, redirect }) {
    // ユーザーが認証されていないとき

    router.beforeEach((to, from, next) => {
        if (store.state.user.id === 0) {
            next({
                path: '/end_users/' + `${store.user.id}`,
                query: {
                    redirect: to.fullPath
                }
            })
        }
    })
}