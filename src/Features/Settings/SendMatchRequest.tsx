import React from 'react'
import { Modal } from 'react-native';
import { View } from 'react-native-animatable'
import { Text, Input, Button } from 'react-native-elements';
import { Spacer } from '@components';
import { parsePhoneNumberFromString } from 'libphonenumber-js'

export interface SendMatchRequestPopupProps {
    visible: boolean
    onRequestClose: () => void,
    onSend?: (phone: string) => Promise<any>
}

export const SendMatchRequestPopup: React.FC<SendMatchRequestPopupProps> = (props) => {
    const { visible, onRequestClose } = props

    const [phone, setPhone] = React.useState('');
    const [errorMessage, setErrorMessage] = React.useState('')
    const [isSending, setIsSending] = React.useState(false)

    const onSend = React.useCallback(async () => {
        setIsSending(true)
        const parsedPhone = parsePhoneNumberFromString(phone, 'VN')
        if (parsedPhone?.isValid()) {
            await props.onSend?.(parsedPhone.number as string)
            setErrorMessage('')
            setIsSending(false)
            return
        }
        setErrorMessage('Invalid phone number!')
        setIsSending(false)
    }, [phone]);

    function renderContent() {
        return (
            <View
                style={{ backgroundColor: '#ffffff', width: '70%', alignSelf: 'center', padding: 16, borderRadius: 8 }}
                animation='slideInUp'
                duration={250}
                useNativeDriver
            >
                <Text style={{ alignSelf: 'center', fontSize: 18, fontWeight: 'bold' }}>COUPLE  REQUEST</Text>
                <Spacer height={8} />
                <Input
                    value={phone}
                    onChangeText={setPhone}
                    inputStyle={{ textAlign: 'center', fontSize: 15 }}
                    keyboardType='phone-pad'
                    placeholder= "Your lover's phone number"
                    errorMessage={errorMessage}
                />
                <Spacer height={16} />
                <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                    <Button
                        buttonStyle={{ borderColor: '#EE4E9B', paddingVertical: 5, width: 100 }}
                        titleStyle={{ color: '#EE4E9B', fontWeight: '500' }}
                        onPress={onRequestClose}
                        title='Cancel'
                        type='outline'
                    />

                    <Button
                        loading={isSending}
                        buttonStyle={{ backgroundColor: '#EE4E9B', paddingVertical: 5, width: 100 }}
                        titleStyle={{ color: '#ffffff', fontWeight: '500' }}
                        onPress={onSend}
                        title='Send'
                    />
                </View>
            </View>
        )
    }

    return (
        <>
            <Modal
                onRequestClose={onRequestClose}
                visible={visible}
                animationType='none'
                transparent
            >
                <View
                    duration={250}
                    animation='fadeIn'
                    style={{ backgroundColor: 'rgba(51,51,51,0.3)', flex: 1, justifyContent: 'center' }}
                >
                    {renderContent()}
                </View>
            </Modal>
        </>
    )
}
