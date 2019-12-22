import firebase from "@/plugins/firebase"

const db = firebase.firestore();

export default function ({ store, route, redirect }) {
    // currentUserがchatRoomのuser_idに含まれているかどうかを判定
    // 自分が含まれていないchatRoomのidを叩いたらリダイレクト
    db.collection("users").doc(route.params.id).get().then(docSnap => {
        console.log("store.state.user.id", store.state.user.id)
        console.log("docSnap.data().current_user_id", docSnap.data().current_user_id)
        console.log("docSnap.data().user_id", docSnap.data().user_id)
        if (store.state.user.id !== docSnap.data().current_user_id) {
            if (store.state.user.id !== docSnap.data().user_id) {
                return redirect(`/end_users/${docSnap.data().user_id}`)
            }
        }
    })
}