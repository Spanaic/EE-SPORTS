import axios from '@/plugins/axios';

export default async function ({ store, redirect, route }) {
    // 現在のユーザーとpost_imageのend_userが違う場合
    // post_imageの詳細ページへredirect
    const res = await axios.get(`/post_images/${route.params.postImageId}/edit`)
    if (store.state.user.id !== res.data.end_user_id) {
        return redirect(`/post_Images/${route.params.postImageId}`)
    }
}