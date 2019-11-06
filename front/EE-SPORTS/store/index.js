import Vuex from 'vuex';
import mutations from "./mutations"
import state from "./state"
import actions from "./actions";


const createStore = () => {
    return new Vuex.Store({
        state,
        mutations,
        actions,
        getters: {
            user(state) {
                return state.user;
            },
            isSignedIn(state) {
                return state.status;
            }
        }
    })

}

export default createStore;