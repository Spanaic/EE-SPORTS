import firebase from '@/plugins/firebase';
import axios from '@/plugins/axios';

export default (context) => {
    const {
        store
    } = context
    firebase.auth().onAuthStateChanged(async user => {
        // console.log("test")
        if (user) {
            // console.log(user)
            const { data } =
                await axios.get(`/end_users?email=${user.email}`)
            store.commit('setUser', data[0])
            console.log(data);
        }
    })
}

// FIXME:mutationsの名前を変更する！

// created() {
//     firebase.auth().onAuthStateChanged((user) => {
//         if (user) {
//             // ログインしたときに実行するメソッド
//             this.setUser(user)
//         }
//     })
// },
// methods() {
//     ...mapActions([setUser]) // サインイン情報を利用したいストアアクション
// }