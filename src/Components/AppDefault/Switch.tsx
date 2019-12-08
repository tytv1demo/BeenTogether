import React from 'react'
import { Switch, SwitchProps } from 'react-native'

export const ADSwitch: React.FC<SwitchProps> = (props) => {
    return (
        <Switch
            {...props}
            trackColor={{ true: '#EE4E9B', false: '#EFEFEF' }}
        />
    )
}
