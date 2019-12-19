import React from 'react'
import { Avatar, AvatarProps } from 'react-native-elements'

export const UserAvatar: React.FC<AvatarProps> = (props) => {
    const { source } = props
    return (
        <Avatar
            {...props}
            source={source || {uri: 'https://cdn1.iconfinder.com/data/icons/technology-devices-2/100/Profile-512.png'}}
        />
    )
}

export const MemoAvatar = React.memo(UserAvatar)
