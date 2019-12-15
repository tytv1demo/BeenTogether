import { NativeModules, EventSubscription, NativeEventEmitter } from 'react-native'
import { BehaviorSubject } from 'rxjs'
import { UserInfo } from './User'
import { UserInfoDidChangedPayload } from './Types';

export const ModuleName = 'RNAppUserDataBridge'

const BridgeModule = NativeModules[ModuleName]

const ModuleEventEmitter = new NativeEventEmitter(BridgeModule)

export class AppUserData {

    static instance: AppUserData

    static shared() {
        if (!AppUserData.instance) {
            AppUserData.instance = new AppUserData()
        }
        return AppUserData.instance
    }

    static userInfoChangedEvent = 'userInfoChangedEvent'

    userInfo: BehaviorSubject<UserInfo>

    userInfoSubscription: EventSubscription

    constructor() {
        this.userInfo = new BehaviorSubject<UserInfo>(BridgeModule.data.userInfo)
        this._onUserInfoDidChange = this._onUserInfoDidChange.bind(this)
        this.userInfoSubscription = ModuleEventEmitter.addListener(
            BridgeModule.userInfoChangedEvent,
            this._onUserInfoDidChange,
        )
    }

    _onUserInfoDidChange(e: UserInfoDidChangedPayload) {
        this.userInfo.next(e.userInfo)
    }
}
