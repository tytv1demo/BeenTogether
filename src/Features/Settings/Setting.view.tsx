import React from 'react'
import {
    ScrollView,
} from 'react-native'
import { Avatar, Header, ListItem } from 'react-native-elements'
import { Spacer, ADSwitch, MemoAvatar } from '@components';
import { LocationServices, AppUserData } from '@bridges';
import { SettingScreenState } from './Types'
import { Subscription } from 'rxjs';

export class SettingScreen extends React.PureComponent<any, SettingScreenState> {

    locationServices: LocationServices

    subcription!: Subscription

    constructor(props: any) {
        super(props)
        this.state = {
        }
        this.locationServices = LocationServices.shared()
        this._onAutomaticUpdateLocationStateChanged = this._onAutomaticUpdateLocationStateChanged.bind(this)
    }

    componentDidMount() {
        this.subcription = this.locationServices.isAutomaticUpdateOfLocation.subscribe({ next: this._onAutomaticUpdateLocationStateChanged })
        this.locationServices.enableLocationUpdate()
    }

    componentWillUnmount() {
        this.subcription.unsubscribe()
    }

    onToggleAutomaticUpdate = async () => {
        const isAutomaticUpdate = this.locationServices.isAutomaticUpdateOfLocation.value
        if (isAutomaticUpdate) {
            return await this.locationServices.disableLocationUpdate()
        }
        await this.locationServices.enableLocationUpdate()
    }

    _onAutomaticUpdateLocationStateChanged(value: boolean) {
        this.forceUpdate()
    }

    renderAvatarSection() {
        return (
            <>
                <Spacer />
                <MemoAvatar
                    containerStyle={{ alignSelf: 'center' }}
                    size='xlarge'
                    source={{ uri: 'https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg' }}
                    rounded
                />
                <Spacer />
            </>
        )
    }

    renderMatchSection() {
        return (
            <>
            </>
        )
    }

    renderAccountSettingSection() {
        const { value: userInfo } = AppUserData.shared().userInfo
        return (
            <>
                <ListItem
                    title='Họ và tên'
                    rightTitle={userInfo.name}
                    rightAvatar={<MemoAvatar
                        source={{ uri: 'https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg' }}
                        rounded
                    />}
                    bottomDivider
                />
                <ListItem
                    title='Phone number'
                    rightTitle={userInfo.phoneNumber}
                />
                <Spacer />
            </>
        )
    }

    renderCoupleSection() {
        const { value: userInfo } = AppUserData.shared().userInfo
        if (!userInfo.isPaired) {
            return this.renderMatchSection()
        }
        return (
            <>
                <ListItem
                    title='Đã ghép đôi với'
                    rightTitle='Ngọc Trinh'
                    rightAvatar={<MemoAvatar
                        source={{ uri: 'https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg' }}
                        rounded
                    />}
                    bottomDivider
                />
                <ListItem
                    title='Tự động cập nhật vị trí'
                    rightElement={<ADSwitch
                        onValueChange={this.onToggleAutomaticUpdate}
                        value={LocationServices.shared().isAutomaticUpdateOfLocation.value}
                    />}

                />
            </>
        )
    }

    renderAppInfoSection() {
        return (
            <>
                <ListItem
                    title='Gửi phản hồi'
                    bottomDivider
                />
                <ListItem
                    title='Coppyright'
                    bottomDivider
                />
                <ListItem
                    title='Phiên bản'
                    rightTitle='1.0.0'
                />
            </>
        )
    }

    renderContent() {
        return (
            <>
                {this.renderAvatarSection()}
                {this.renderAccountSettingSection()}
                {this.renderCoupleSection()}
                <Spacer />
                {this.renderAppInfoSection()}
            </>
        )
    }

    render() {
        const { value: userInfo } = AppUserData.shared().userInfo
        if (!userInfo) {
            return null
        }
        return (
            <>
                <Header
                    centerComponent={{ text: 'Cài đặt', style: { fontSize: 20 } }}
                    backgroundColor='white'
                />
                <ScrollView contentContainerStyle={{ backgroundColor: '#EFEFEF', paddingBottom: 83 }}>
                    {this.renderContent()}
                </ScrollView>
            </>
        )
    }
}
        // Sync mode
        // Location update
