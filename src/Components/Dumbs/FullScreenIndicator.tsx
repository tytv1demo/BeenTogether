import React from 'react'
import { Modal } from 'react-native'
import { View } from 'react-native-animatable'

import { PacmanIndicator } from 'react-native-indicators';

export interface FullScreenIndicatorProps {
    visible: boolean
    onRequestClose?: () => void,
}

export const FullScreenIndicator: React.FC<FullScreenIndicatorProps> = (props) => {

    const renderContent = () => {
        return (
            <>
                <PacmanIndicator color='#EE4E9B'/>
            </>
        )
    }

    const { visible, onRequestClose } = props
    return (
        <Modal
            onRequestClose={onRequestClose}
            visible={visible}
            animationType='none'
            transparent
        >
            <View
                duration={250}
                animation='fadeIn'
                style={{ backgroundColor: 'rgba(51,51,51,0.3)', flex: 1, justifyContent: 'center', alignItems: 'center' }}
            >
                {renderContent()}
            </View>
        </Modal>
    )
}
