import Vuex from 'vuex';
import mutations from "./mutations"
import state from "./state"
import actions from "./actions";
export const strict = false;

const store = () => {
    return new Vuex.Store({
        state, // userという状態を定義
        mutations, // 引数の値を代入するメソッド定義
        actions, // firebaseにアクセスし、mutations.setUserを呼び出しuserの値を実際に代入
        getters: {
            user(state) {
                return state.user;
            },
            isSignedIn(state) {
                return state.status;
            },
            search(state) {
                return state.search;
            },
            notifications(state) {
                return state.notifications;
            }
        }
    })
}
export default store;