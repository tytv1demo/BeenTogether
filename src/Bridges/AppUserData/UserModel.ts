import { User } from './Types';
import { ApiManager } from '@dataManager';

export class UserModel {

    apiManager: ApiManager

    userInfo: User

    isPaired: boolean = false

    constructor(userInfo: User, apiManager: ApiManager) {
        this.userInfo = userInfo
        this.apiManager = apiManager
        this.isPaired = this._isPaired()
    }

    private _isPaired(): boolean {
        return !this.userInfo.coupleId.includes('local')
    }

}
