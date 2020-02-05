import React from 'react'
import {
    ScrollView, View, TouchableWithoutFeedback, Alert, Linking,
} from 'react-native'
import { Header, ListItem, Text, Icon } from 'react-native-elements'
import { Spacer, ADSwitch, MemoAvatar, FullScreenIndicator } from '@components';
import { LocationServices, AppUserData, UserModel, CoupleModel, showFlashMessage } from '@bridges';
import { SettingScreenState } from './Types'
import { Subscription } from 'rxjs';
import { ApiManager, CoupleService } from '@dataManager';

import { PulseCircles } from './PulseCircles';
import { PulseIndicator } from 'react-native-indicators';
import { SendMatchRequestPopup } from './SendMatchRequest';
import { contactUs } from '../MessageAlert/MessageAlertBridge';

export class SettingScreen extends React.PureComponent<any, SettingScreenState> {

    locationServices: LocationServices

    appUserData: AppUserData

    subcription!: Subscription

    coupleService: CoupleService

    constructor(props: any) {
        super(props)
        this.state = {
            requestPopupVisible: false,
            isRequestBreakingUp: false,
        }
        this.locationServices = LocationServices.shared()
        this._onAutomaticUpdateLocationStateChanged = this._onAutomaticUpdateLocationStateChanged.bind(this)
        const apiManger = new ApiManager({
            baseURL: 'https://cupid-api.tranty9597.now.sh',
            // baseURL: 'http://localhost:3000',
        })
        this.appUserData = new AppUserData(apiManger)
        this.coupleService = new CoupleService(apiManger);
    }

    componentDidMount() {
        this.subcription = this.locationServices.isAutomaticUpdateOfLocation.subscribe({ next: this._onAutomaticUpdateLocationStateChanged })
        this.subcription.add(this.appUserData.token.subscribe({ next: this.onTokenChanged }))
    }

    componentWillUnmount() {
        this.subcription.unsubscribe()
    }

    private async syncUserData() {
        const user = await this.appUserData.fetchUserInfo()
        const userModel = new UserModel(user, this.appUserData.apiManger);
        const coupleModel = new CoupleModel(user, this.appUserData.apiManger)
        if (userModel.isPaired) {
            await coupleModel.syncLoverProfile()
        }
        this.setState({ userModel, coupleModel })
    }

    private onTokenChanged = (token: string | undefined) => {
        if (token) {
            this.syncUserData()
        }
    }

    sendMatchRequest = async (phoneNumber: string) => {
        try {
            await this.coupleService.sendMatchRequest(phoneNumber);
            showFlashMessage('Congratulation', 'Send request successfully', 'success')
            this.setState({ requestPopupVisible: false })
        } catch (error) {
            showFlashMessage('Oops!', error.message)
        }

    }

    onLogout = () => {
        Alert.alert(
            'Cofirmation',
            'Are you sure you want to log out?',
            [
                {
                    text: 'YES',
                    onPress: this.appUserData.logout,
                },
                {
                    text: 'NO',
                },
            ],
        )
    }

    onBreakUp = () => {
        const doBreakUp = async () => {
            this.setState({ isRequestBreakingUp: true })
            await this.coupleService.breakUp()
            await this.state.userModel?.syncUserInfo()
            showFlashMessage('Yeah!', 'Breakup successfully!', 'success')
            this.setState({ isRequestBreakingUp: false })
        }
        const { coupleModel } = this.state
        Alert.alert('Warning', `Are you sure to break up ${coupleModel?.lover.name}`, [
            { text: 'Absolutely', onPress: doBreakUp },
            { text: 'Nope' },
        ])

    }

    onUserModelChanged = () => {
        this.forceUpdate()
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

    onOpenRequestPopup = () => {
        this.setState({ requestPopupVisible: true })
    }

    onRequestCloseRequestPopup = () => {
        this.setState({ requestPopupVisible: false })
    }

    onContactUs = async () => {
        await contactUs()
    }

    renderAvatarSection() {
        const { userInfo } = this.state.userModel!

        return (
            <>
                <Spacer />
                <MemoAvatar
                    containerStyle={{ alignSelf: 'center' }}
                    size='xlarge'
                    title={userInfo.name}
                    // source={{ uri: 'https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg' }}
                    rounded
                />
                <Spacer />
            </>
        )
    }

    renderMatchSection() {
        return (
            <>
                <PulseCircles>
                    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
                        <Icon
                            Component={TouchableWithoutFeedback}
                            onPress={this.onOpenRequestPopup}
                            name='heartbeat'
                            type='font-awesome'
                            color='#ffffff'
                        />
                    </View>
                </PulseCircles>
                <Text style={{ alignSelf: 'center', margin: 40 }}>Touch to make a matching request</Text>
            </>
        )
    }

    renderAccountSettingSection() {
        const { userInfo } = this.state.userModel!
        return (
            <>
                <ListItem
                    title='Your name'
                    rightContentContainerStyle={{ flex: 1 }}
                    rightTitle={userInfo.name}
                    rightAvatar={<MemoAvatar
                        title={userInfo.name}
                        rounded
                    />}
                    bottomDivider
                />
                <ListItem
                    title='Phone number'
                    rightTitle={userInfo.phoneNumber}
                    rightContentContainerStyle={{ flex: 1 }}
                    bottomDivider
                />
                <ListItem
                    title='Logout'
                    titleStyle={{ color: 'red' }}
                    onPress={this.onLogout}
                // rightIcon={{ name: 'log-out', type: 'ionicon' }}
                />
                <Spacer />
            </>
        )
    }

    renderCoupleSection() {
        const { coupleModel, userModel } = this.state

        if (!userModel?.isPaired) {
            return this.renderMatchSection()
        }
        const { lover } = coupleModel!
        return (
            <>
                <ListItem
                    title='Match with'
                    rightTitle={lover.name}
                    rightContentContainerStyle={{ flex: 1 }}
                    rightAvatar={<MemoAvatar
                        title={lover.name}
                        rounded
                    />}
                    bottomDivider
                />
                <ListItem
                    title='Auto update your location'
                    rightElement={<ADSwitch
                        onValueChange={this.onToggleAutomaticUpdate}
                        value={LocationServices.shared().isAutomaticUpdateOfLocation.value}
                    />}
                    bottomDivider
                />
                <ListItem
                    title='Breakup'
                    titleStyle={{ color: 'red' }}
                    onPress={this.onBreakUp}
                    chevron
                />
                <Spacer />
            </>
        )
    }

    renderAppInfoSection() {
        return (
            <>
                <ListItem
                    onPress={this.onContactUs}
                    title='Contact us'
                    bottomDivider
                    chevron
                />
                <ListItem
                    title='Copyright'
                    rightTitle='Tmlq'
                    bottomDivider
                />
                <ListItem
                    title='Version'
                    rightTitle='1.0.4'
                />
            </>
        )
    }

    render() {
        const { userModel } = this.state
        if (typeof userModel === 'undefined') {
            return <PulseIndicator color='#EE4E9B' />
        }
        return (
            <>
                <Header
                    centerComponent={{ text: 'Settings', style: { fontSize: 20 } }}
                    backgroundColor='white'
                />
                <ScrollView contentContainerStyle={{ backgroundColor: '#EFEFEF', paddingBottom: 83 }}>
                    {this.renderContent()}
                </ScrollView>
            </>
        )
    }

    renderContent() {
        return (
            <>
                {this.renderAvatarSection()}
                {this.renderAccountSettingSection()}
                {this.renderCoupleSection()}
                {this.renderAppInfoSection()}
                <SendMatchRequestPopup
                    onRequestClose={this.onRequestCloseRequestPopup}
                    visible={this.state.requestPopupVisible}
                    onSend={this.sendMatchRequest}
                />
                <FullScreenIndicator visible={this.state.isRequestBreakingUp} />
            </>
        )
    }
}
