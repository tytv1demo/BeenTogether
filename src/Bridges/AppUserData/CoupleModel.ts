import { ApiManager } from '@dataManager';
import { User, BaseResult, GetUserProfileResult } from './Types';
export class CoupleModel {
    user: User

    lover!: User

    apiManger: ApiManager

    constructor(user: User, apiManger: ApiManager) {
        this.user = user
        this.apiManger = apiManger
    }

    getLoverId = () => {
        const raw = this.user.coupleId.split('_')
            .find(x => Number(x) !== this.user.id);
        if (raw === 'local') {
            return -1;
        }
        return Number(raw);
    }

    async syncLoverProfile() {
        const loverId = this.getLoverId()
        const { data: response } = await this.apiManger.get<BaseResult<GetUserProfileResult>>(`/user/friend-profile?id=${loverId}`)
        return this.lover = response.data.userInfo
    }
}
