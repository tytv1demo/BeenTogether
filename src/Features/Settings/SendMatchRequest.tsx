import React from 'react'
import { Modal } from 'react-native';
import { View } from 'react-native-animatable'
import { Text, Input, Button } from 'react-native-elements';
import { Spacer } from '@components';

export interface SendMatchRequestPopupProps {
    visible: boolean
    onRequestClose: () => void
}

export const SendMatchRequestPopup: React.FC<SendMatchRequestPopupProps> = (props) => {
    const { visible, onRequestClose } = props

    function renderContent() {
        return (
            <View
                style={{ backgroundColor: '#ffffff', width: '80%', alignSelf: 'center', padding: 16, borderRadius: 8 }}
                animation='slideInUp'
                useNativeDriver
            >
                <Text style={{ alignSelf: 'center' }} h4> Gửi lời mời</Text>
                <Spacer height={8} />
                <Input
                    inputStyle={{ textAlign: 'center' }}
                    keyboardType='phone-pad'
                    placeholder='Phone number'
                />
                <Spacer height={16} />
                <View style={{ flexDirection: 'row', justifyContent: 'space-around' }}>
                    <Button
                        buttonStyle={{ borderColor: '#EE4E9B', paddingVertical: 4, width: 80 }}
                        titleStyle={{ color: '#EE4E9B' }}
                        onPress={onRequestClose}
                        title='Cancel'
                        type='outline'
                    />

                    <Button
                        buttonStyle={{ backgroundColor: '#EE4E9B', paddingVertical: 4, width: 80 }}
                        titleStyle={{ color: '#ffffff' }}
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
                    animation='fadeIn'
                    style={{ backgroundColor: 'rgba(51,51,51,0.3)', flex: 1, justifyContent: 'center' }}
                >
                    {renderContent()}
                </View>
            </Modal>
        </>
    )
}
