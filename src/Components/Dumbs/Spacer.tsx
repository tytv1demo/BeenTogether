import React from 'react'
import { View } from 'react-native'

export interface SpacerProps {
    height?: number
}

export const Spacer: React.FC<SpacerProps> = (props) => {
    const { height = 40 } = props
    return (
        <View style={{ height }
        } />
    )
}
