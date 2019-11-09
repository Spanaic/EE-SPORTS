const mutations = {
    setUser(state, payload) {
        state.user = payload;
    },
    onUserStatusChanged(state, payload) {
        state.status = payload;
    }
};

export default mutations;