import { User, BaseResult, GetUserProfileResult } from './Types';
import { ApiManager } from '@dataManager';

export class UserModel {

    apiManager: ApiManager

    userInfo: User

    get isPaired(): boolean {
        return !this.userInfo.coupleId.includes('local')
    }

    constructor(userInfo: User, apiManager: ApiManager) {
        this.userInfo = userInfo
        this.apiManager = apiManager
    }

    async syncUserInfo(): Promise<User> {
        const { data: response } = await this.apiManager.get<BaseResult<GetUserProfileResult>>('/user/profile')
        this.userInfo = response.data.userInfo
        return this.userInfo
    }
}
