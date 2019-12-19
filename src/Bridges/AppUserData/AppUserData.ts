import { CoupleModel } from './CoupleModel';
import { NativeModules, EventSubscription, NativeEventEmitter } from 'react-native'
import { BehaviorSubject } from 'rxjs'
import { GetUserProfileResult, BaseResult, User } from './Types';
import { UserModel } from './UserModel'
import { ApiManager } from '@dataManager';

export const ModuleName = 'RNAppUserDataBridge'

const BridgeModule = NativeModules[ModuleName]

const ModuleEventEmitter = new NativeEventEmitter(BridgeModule)

export type FetchStatus = 'INIT' | 'LOADING' | 'DONE' | 'FAIL'

export class AppUserData {

    static userInfoChangedEvent = 'userInfoChangedEvent'

    apiManger: ApiManager

    userTokenSubscription: EventSubscription

    token: BehaviorSubject<string | undefined>

    constructor(apiManger: ApiManager) {
        this.apiManger = apiManger
        this.token = new BehaviorSubject<string | undefined>(undefined)
        this.userTokenSubscription = ModuleEventEmitter.addListener(
            BridgeModule.userTokenChanged,
            this.onUserTokenChanged,
        )
    }

    async fetchUserInfo(): Promise<User> {
        const { data: response } = await this.apiManger.get<BaseResult<GetUserProfileResult>>('/user/profile')
        return response.data.userInfo
    }

    onUserTokenChanged = (token: string) => {
        this.apiManger.setToken(token)
        this.token.next(token)
    }
}
