export default function ({ store, redirect, route }) {
    // 現在のユーザーとリクエストされたユーザーが食い違う場合
    // console.log("route.params.userId", route.params.userId)
    // console.log("store.state.user.id", store.state.user.id)
    // console.log("真偽値", parseInt(route.params.userId) === store.state.user.id)

    // console.log("type of route.params.userId", typeof route.params.userId);
    // console.log("toString store.state.user.id", toString.call(store.state.user.id));
    // console.log("type of store.state.user.id", typeof store.state.user.id);
    // console.log("toString route.params.userId", toString.call(route.params.userId));

    if (parseInt(route.params.userId) !== store.state.user.id) {
        return redirect(`/end_users/${store.state.user.id}`)
    }
}