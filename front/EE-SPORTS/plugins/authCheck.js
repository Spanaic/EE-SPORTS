import firebase from '@/plugins/firebase';
import axios from 'axios';

export default (context) => {
    const {
        store
    } = context
    firebase.auth().onAuthStateChanged(async user => {
        if (user) {
            // const { data } =

            // await axios.get("http://localhost:3001/users/",{
            //     params:{
            //         email: user.email
            //     }
            // })
            store.commit('onAuthStateChanged', user)
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