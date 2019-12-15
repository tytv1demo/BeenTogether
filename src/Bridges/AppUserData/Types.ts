import { UserInfo } from './User';

export interface UserInfoDidChangedPayload {
    userInfo: UserInfo
    ifPaired: boolean
}
