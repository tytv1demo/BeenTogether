import React from 'react'
import { View } from 'react-native'
import { Overlay, Text, Button } from 'react-native-elements';
import { Spacer, MemoAvatar } from '@components';
import { selectAction } from './MessageAlertBridge';

export interface MessageAlertViewProps {
    id: string
    title: string,
    message: string
}

export const MessageAlertView: React.FC<MessageAlertViewProps> = (props) => {

    const onOKPress = React.useCallback(() => selectAction(props.id, 'OK'), [])

    function renderIcon() {
        return (
            <MemoAvatar
                containerStyle={{ alignSelf: 'center', position: 'absolute', top: -35, borderWidth: 2, borderColor: '#FFFFFF' }}
                source={{ uri: 'https://vcdn-ngoisao.vnecdn.net/2019/07/11/tran-kieu-an-5-6648-1562814204.jpg' }}
                size='large'
                rounded
            />
        )
    }
    function renderButton() {
        return (
            <View style={{ flexDirection: 'row', justifyContent: 'center' }}>
                <Button
                    title='Okay'
                    onPress={onOKPress}
                    containerStyle={{ width: 70 }}
                />
            </View>
        )
    }
    return (
        <Overlay
            containerStyle={{ flex: 1 }}
            overlayStyle={{ width: '80%', height: 'auto' }}
            isVisible>
            <>
                {renderIcon()}
                <Text style={{ textAlign: 'center', marginTop: 35 }} h4>{props.title}</Text>
                <Spacer height={8} />
                <Text style={{ textAlign: 'center' }} >{props.message}</Text>
                <Spacer height={8} />
                {renderButton()}
            </>
        </Overlay>
    )
}
